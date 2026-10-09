/*
  Script DML: Carga e Deduplicação tb_vendas_marcas_gb
  Execução direta via CI/CD (compatível com BigQuery Free Tier)
*/

MERGE `trusted-zone-510905.case_boticario_analytics.tb_vendas_marcas_gb` T
USING (
  WITH max_data AS (
    SELECT COALESCE(MAX(EXTRACT(DATE FROM SAFE_CAST(DATA_VENDA AS DATETIME))), CURRENT_DATE()) AS max_dt
    FROM `raw-zone-510905.case_boticario_analytics.tb_vendas_marcas_gb`
  ),
  dados_sanitizados AS (
    SELECT
      EXTRACT(DATE FROM SAFE_CAST(R.DATA_VENDA AS DATETIME)) AS dt_venda,
      SAFE_CAST(R.ID_MARCA AS INT64) AS cod_marca,
      REGEXP_REPLACE(NORMALIZE(TRIM(UPPER(R.MARCA)), NFD), r'\pM', '') AS nome_marca,
      SAFE_CAST(R.ID_LINHA AS INT64) AS cod_linha,
      REGEXP_REPLACE(NORMALIZE(TRIM(UPPER(R.LINHA)), NFD), r'\pM', '') AS nome_linha,
      SAFE_CAST(R.QTD_VENDA AS INT64) AS qt_venda,
      R.data_hora_ingestao
    FROM `raw-zone-510905.case_boticario_analytics.tb_vendas_marcas_gb` R
    CROSS JOIN max_data M
    WHERE EXTRACT(DATE FROM SAFE_CAST(R.DATA_VENDA AS DATETIME)) >= DATE_SUB(M.max_dt, INTERVAL 30 DAY)
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
  ) = 1
) S
ON  T.dt_venda  = S.dt_venda
AND T.cod_marca = S.cod_marca
AND T.cod_linha = S.cod_linha

WHEN MATCHED THEN
  UPDATE SET
    T.nome_marca        = S.nome_marca,
    T.nome_linha        = S.nome_linha,
    T.nr_ano            = S.nr_ano,
    T.nr_mes            = S.nr_mes,
    T.qt_venda          = S.qt_venda,
    T.dt_hr_atualizacao = S.dt_hr_atualizacao

WHEN NOT MATCHED THEN
  INSERT (
    dt_venda, nr_ano, nr_mes, cod_marca, nome_marca, 
    cod_linha, nome_linha, qt_venda, dt_hr_atualizacao
  )
  VALUES (
    S.dt_venda, S.nr_ano, S.nr_mes, S.cod_marca, S.nome_marca, 
    S.cod_linha, S.nome_linha, S.qt_venda, S.dt_hr_atualizacao
  );