-- Validação de consistência 1:N entre IDs e Nomes de Marcas/Linhas


-- validação id único por marca
SELECT 
    ID_MARCA, 
    COUNT(DISTINCT TRIM(UPPER(MARCA))) AS qtd_marcas_distintas,
    STRING_AGG(DISTINCT TRIM(UPPER(MARCA)), ', ') AS nomes_marcas
FROM `raw-zone-510905.case_boticario_analytics.tb_vendas_marcas_gb`
GROUP BY 1
HAVING COUNT(DISTINCT TRIM(UPPER(MARCA))) > 1;

-- validação id único por linha
SELECT 
    ID_LINHA, 
    COUNT(DISTINCT TRIM(UPPER(LINHA))) AS qtd_linhas_distintas,
    STRING_AGG(DISTINCT TRIM(UPPER(LINHA)), ', ') AS nomes_linhas
FROM `raw-zone-510905.case_boticario_analytics.tb_vendas_marcas_gb`
GROUP BY 1
HAVING COUNT(DISTINCT TRIM(UPPER(LINHA))) > 1;