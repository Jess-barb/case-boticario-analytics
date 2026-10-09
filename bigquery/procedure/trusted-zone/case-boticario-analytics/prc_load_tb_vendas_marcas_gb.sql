/*
  Carga e Recriação Física da Tabela com Particionamento e Cluster
  Compatível com BigQuery Free Tier (DDL / CTAS)
*/
CREATE OR REPLACE TABLE `case_boticario_analytics.tb_vendas_marcas_gb` AS


WITH max_data AS (
  -- Identifica a maior data disponível na base (seja histórica ou atual)
  SELECT COALESCE(MAX(EXTRACT(DATE FROM SAFE_CAST(DATA_VENDA AS DATETIME))), CURRENT_DATE()) AS max_dt
  FROM `raw-zone-510905.case_boticario_analytics.tb_vendas_marcas_gb`
),
dados_sanitizados AS (
  SELECT
    EXTRACT(DATE FROM SAFE_CAST(vmg.DATA_VENDA AS DATETIME)) AS dt_venda,
    SAFE_CAST(vmg.ID_MARCA AS INT64) AS cod_marca,
    REGEXP_REPLACE(NORMALIZE(TRIM(UPPER(vmg.MARCA)), NFD), r'\pM', '') AS nome_marca,
    SAFE_CAST(vmg.ID_LINHA AS INT64) AS cod_linha,
    REGEXP_REPLACE(NORMALIZE(TRIM(UPPER(vmg.LINHA)), NFD), r'\pM', '') AS nome_linha,
    SAFE_CAST(vmg.QTD_VENDA AS INT64) AS qt_venda,
    vmg.data_hora_ingestao
  FROM `raw-zone-510905.case_boticario_analytics.tb_vendas_marcas_gb` vmg
  CROSS JOIN max_data md
  -- Filtra os últimos 30 dias com base na maior data presente na origem
  WHERE EXTRACT(DATE FROM SAFE_CAST(vmg.DATA_VENDA AS DATETIME)) >= DATE_SUB(md.max_dt, INTERVAL 30 DAY)
)
SELECT
  dt_venda,
  EXTRACT(YEAR FROM dt_venda) AS nr_ano,
  EXTRACT(MONTH FROM dt_venda) AS nr_mes,
  cod_marca,
  nome_marca,
  cod_linha,
  nome_linha,
  qt_venda,
  CURRENT_TIMESTAMP() AS dt_hr_atualizacao
FROM dados_sanitizados
WHERE dt_venda IS NOT NULL
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY cod_marca, cod_linha, dt_venda
  ORDER BY data_hora_ingestao DESC
) = 1;