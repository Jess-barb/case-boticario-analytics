import os
import glob
import shutil
from datetime import datetime
import pandas as pd
from google.cloud import bigquery

def executar_ingestao_raw_tb_vendas_marcas_gb():
    project_id = "raw-zone-510905"
    dataset_id = "case_boticario_analytics"
    table_id = f"{project_id}.{dataset_id}.tb_vendas_marcas_gb"

    # Inicializa o cliente usando as credenciais que já autenticaste no gcloud
    client = bigquery.Client(project=project_id)

    path_raw = os.path.join("data", "raw", "*.xlsx")
    path_processed = os.path.join("data", "processed")
    os.makedirs(path_processed, exist_ok=True)

    arquivos_excel = glob.glob(path_raw)

    if not arquivos_excel:
        print("Nenhum arquivo novo em 'data/raw/'.")
        return

    dfs = []
    dh_atual = datetime.now()

    for caminho_arquivo in arquivos_excel:
        nome_arquivo = os.path.basename(caminho_arquivo)
        
        # Leitura fiel 1:1 em String
        df = pd.read_excel(caminho_arquivo, dtype=str)
        
        # Metadados de auditoria e linhagem
        df['nome_arquivo'] = nome_arquivo
        df['data_hora_ingestao'] = dh_atual

        dfs.append((caminho_arquivo, df))

    df_novos_dados = pd.concat([d[1] for d in dfs], ignore_index=True)

    job_config = bigquery.LoadJobConfig(
        write_disposition=bigquery.WriteDisposition.WRITE_APPEND
    )

    print(f"Carregando {len(df_novos_dados)} linhas na tabela bruta {table_id}...")
    job = client.load_table_from_dataframe(df_novos_dados, table_id, job_config=job_config)
    job.result() # Aguarda a conclusão da carga

    # Mover ficheiros processados para a pasta processed
    for caminho_arquivo, _ in dfs:
        nome_arquivo = os.path.basename(caminho_arquivo)
        shutil.move(caminho_arquivo, os.path.join(path_processed, nome_arquivo))

    print("Ingestão RAW concluída com sucesso!")

if __name__ == "__main__":
    executar_ingestao_raw_tb_vendas_marcas_gb()