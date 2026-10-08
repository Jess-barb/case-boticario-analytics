-- Auditoria de datas vs. nomes dos arquivos de origem
-- Utilizado para identificar a inconsistencia do arquivo base_2017.xlsx conter registros de 2019

SELECT 
    nome_arquivo,
    EXTRACT(YEAR FROM SAFE_CAST(DATA_VENDA AS DATETIME)) AS ano_extraido_data,
    MIN(DATA_VENDA) AS menor_data,
    MAX(DATA_VENDA) AS maior_data,
    COUNT(*) AS total_linhas
FROM `raw-zone-510905.case_boticario_analytics.tb_vendas_marcas_gb`
GROUP BY 1, 2