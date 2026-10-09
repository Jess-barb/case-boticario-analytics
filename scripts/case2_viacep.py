import requests
import re

def consultar_viacep(ceps):
    url_base = "https://viacep.com.br/ws/{}/json/"

    for cep_raw in ceps:
        cep_limpo = re.sub(r'\D', '', str(cep_raw))

        if len(cep_limpo) != 8:
            print(f"Erro: O CEP '{cep_raw}' possui um formato inválido (deve conter 8 dígitos).")
            continue

        url = url_base.format(cep_limpo)

        try:
            response = requests.get(url, timeout=10)
            response.raise_for_status()
            dados = response.json()

            if "erro" in dados and dados["erro"] is True:
                print(f"Erro: O CEP '{cep_raw}' não foi encontrado na base do ViaCEP.")
                continue

            cep_formatado = dados.get("cep", cep_raw)
            logradouro = dados.get("logradouro") or "Não informado"
            bairro = dados.get("bairro") or "Não informado"
            localidade = dados.get("localidade") or "Não informado"
            uf = dados.get("uf") or "Não informado"

            print(f"CEP: {cep_formatado} | Logradouro: {logradouro} | Bairro: {bairro} | Cidade/UF: {localidade}-{uf}")

        except requests.exceptions.RequestException as e:
            print(f"Erro de conexão ao consultar o CEP {cep_raw}: {e}")

ceps_para_processar = [
    "90010-900",  # Praça Marechal Deodoro, RS
    "70100-000",  # Praça dos Três Poderes, DF
    "80010-000",  # Centro, Curitiba - PR
    "12345"       # Teste de validação de erro (formato inválido)
]

if __name__ == "__main__":
    consultar_viacep(ceps_para_processar)