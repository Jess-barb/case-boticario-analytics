SELECT 
    COUNT(*) AS total_linhas,
    COUNTIF(ID_MARCA IS NULL OR ID_MARCA = '') AS nulos_id_marca,
    COUNTIF(MARCA IS NULL OR MARCA = '') AS nulos_marca,
    COUNTIF(ID_LINHA IS NULL OR ID_LINHA = '') AS nulos_id_linha,
    COUNTIF(LINHA IS NULL OR LINHA = '') AS nulos_linha,
    COUNTIF(DATA_VENDA IS NULL OR DATA_VENDA = '') AS nulos_data_venda,
    COUNTIF(QTD_VENDA IS NULL OR QTD_VENDA = '') AS nulos_qtd_venda
FROM `raw-zone-510905.case_boticario_analytics.tb_vendas_marcas_gb`