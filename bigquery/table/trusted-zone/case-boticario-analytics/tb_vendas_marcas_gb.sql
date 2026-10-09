CREATE OR REPLACE TABLE `case_boticario_analytics.tb_vendas_marcas_gb`
(
  dt_venda DATE OPTIONS(description="Data em que ocorreu a venda (YYYY-MM-DD)"),
  nr_ano INT64 OPTIONS(description="Ano da venda"),
  nr_mes INT64 OPTIONS(description="Mês da data de venda (1 a 12)"),
  cod_marca INT64 OPTIONS(description="Código identificador único da marca"),
  nome_marca STRING OPTIONS(description="Nome Marca"),
  cod_linha INT64 OPTIONS(description="Código identificador único da linha"),
  nome_linha STRING OPTIONS(description="Nome da linha"),
  qt_venda INT64 OPTIONS(description="Quantidade total de itens vendidos"),
  dt_hr_atualizacao TIMESTAMP OPTIONS(description="Data e hora do processamento/carga")
)

OPTIONS(
  description="Tabela consolidada de vendas das marcas e linhas de produtos do GB"
);