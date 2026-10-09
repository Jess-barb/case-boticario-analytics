import functions_framework
from google.cloud import bigquery

@functions_framework.http
def run_trusted_pipeline(request):
    client = bigquery.Client()
    
    # Chama diretamente a Stored Procedure criada no dataset
    query = "CALL `case_boticario_analytics.prc_load_tb_vendas_marcas_gb`();"
    
    try:
        query_job = client.query(query)
        query_job.result()  # Aguarda a finalização da execução no BQ
        return ("Stored Procedure executada com sucesso!", 200)
    except Exception as e:
        return (f"Erro ao chamar a Procedure: {str(e)}", 500)