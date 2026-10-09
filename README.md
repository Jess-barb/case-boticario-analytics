# 🚀 Case Técnico Analytics Engineering - Grupo Boticário

Este repositório contém a solução do case técnico para a posição de **Analytics Engineering** no Grupo Boticário. O objetivo principal do projeto é estruturar, orquestrar, sanitizar e consolidar pipelines de dados de vendas utilizando **Python**, **BigQuery (GCP)** e **GitHub Actions**.

---

## 📐 Arquitetura da Solução e Camadas de Dados

A arquitetura foi desenhada seguindo as melhores práticas de Engenharia de Dados em Nuvem, dividida em dois projetos distintos no **Google Cloud Platform (GCP)**:

1. **RAW Zone (`raw-zone-510905`):**
   * Armazenamento dos dados brutos ingeridos via pipeline em Python.
   * Preservação dos metadados de auditoria (`nome_arquivo`, `data_hora_ingestao`).
   * Tabela de Origem: `case_boticario_analytics.tb_vendas_marcas_gb`.

2. **Trusted Zone (`trusted-zone-510905`):**
   * Tratamento, sanitização de tipos, correção de encoding e deduplicação de registos.
   * Execução de lógica de limpeza via **Stored Procedure** (`prc_load_tb_vendas_marcas_gb`).
   * Construção de modelos dimensionais consolidados de negócio para suporte a decisões analíticas.

---

## 🛠️ Tecnologias e Ferramentas Utilizadas

* **Linguagem de Programação:** Python 3.11 (Pandas, PyArrow, Google Cloud SDK)
* **Data Warehouse:** Google BigQuery (GCP)
* **Orquestração e CI/CD:** GitHub Actions (Workflows automatizados)
* **Modelagem de Dados:** SQL (BigQuery SQL) / DDLs documentados com metadados

---

## 🔍 Principais Desafios de Dados Trata-dos (Data Quality)

Durante a fase de descoberta de dados (Data Discovery), foram identificadas e corrigidas as seguintes anomalias na camada RAW:
* **Troca e mistura de conteúdo nos ficheiros:** Ficheiros com nomenclatura divergente do conteúdo interno (ex: `Base_2017.xlsx` contendo dados de 2019 e vice-versa). A lógica de extração temporal foi baseada estritamente no campo de data real (`dt_venda` / `DATA_VENDA`).
* **Deduplicação de volumetria:** Identificação e eliminação de registos duplicados na camada RAW, resultando num volume final limpo e higienizado de **1.992 registos únicos** na Trusted Zone.

---

## 📊 Modelagem e Tabelas Consolidadas (Trusted Zone)

A partir da tabela limpa principal (`tb_vendas_marcas_gb`), foram construídas 4 tabelas consolidadas com DDLs totalmente documentados:

1. **`tb_vendas_marcas_ano_mes`**: Consolidado de vendas totais agrupado por ano e mês.
2. **`tb_vendas_marca_linha`**: Consolidado de vendas agrupado por hierarquia de produto (marca e linha).
3. **`tb_vendas_ano_mes`**: Visão temporal de vendas agrupada por ano e mês.
4. **`tb_vendas_linha_ano_mes`**: Visão temporal de vendas agrupada por linha de produto, ano e mês.
Tabelas armazenadas neste link - https://console.cloud.google.com/bigquery?ws=!1m4!1m3!3m2!1strusted-zone-510905!2scase_boticario_analytics
---

## 📁 Estrutura do Repositório

```text
.
├── .github/
│   └── workflows/
│       └── ingestao_raw.yml       # Workflow CI/CD do GitHub Actions para carga RAW
├── data/
│   ├── raw/                      # Ficheiros brutos de entrada (.xlsx)
│   └── processed/                # Ficheiros processados localmente
├── scripts/
│   └── ingestao_raw_tb_vendas_marcas_gb.py # Script Python de orquestração/carga
├── sql/
│   ├── ddls/                     # DDLs das tabelas RAW e Trusted
│   └── procedures/               # Stored Procedures de sanitização e carga
└── README.md                     # Documentação do projeto
