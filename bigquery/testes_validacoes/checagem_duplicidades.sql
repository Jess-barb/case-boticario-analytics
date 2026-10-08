-- Checagem de registros exatamente duplicados na camada RAW

SELECT 
    ID_MARCA,
    MARCA,
    ID_LINHA,
    LINHA,
    DATA_VENDA,
    QTD_VENDA,
    COUNT(*) AS qtd_duplicidade
FROM `raw-zone-510905.case_boticario_analytics.tb_vendas_marcas_gb`
GROUP BY 1, 2, 3, 4, 5, 6
HAVING count(*) > 1