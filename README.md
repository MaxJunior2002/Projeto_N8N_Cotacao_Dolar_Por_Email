# 🚀 Teste Técnico Onfly - Automação de E-mails com Cotação do Dólar

## 🎯 Visão Geral do Projeto

Este repositório contém o projeto de automação desenvolvido para o Teste Técnico da Onfly. O workflow utiliza o **n8n** para processar e-mails com anexos CSV, buscar a cotação do dólar (USD/BRL) na API **Open ER-API**, e enviar uma confirmação ao remetente original.

### 🔗 Link do Repositório
[https://github.com/MaxJunior2002/Projeto_N8N_Cotacao_Dolar_Por_Email](https://github.com/MaxJunior2002/Projeto_N8N_Cotacao_Dolar_Por_Email)

### 📂 Arquivos Chave
O projeto usa os seguintes arquivos no diretório raiz:
* **Workflow:** `TesteOnfly_MaximilianoAugusto.json`
* **CSV de Teste:** `csv_teste.csv` (disponível para uso imediato)

---

## 🛠️ Setup e Execução (Docker Compose)

O ambiente utiliza Docker para garantir consistência e persistência de dados (incluindo as credenciais).

### 1. Pré-requisitos
* **Docker Desktop** (ou motor Docker) instalado e rodando.
* **Git** instalado.

### 2. Inicialização do Projeto

1.  **Clonar o Repositório:**
    ```bash
    git clone [https://github.com/MaxJunior2002/Projeto_N8N_Cotacao_Dolar_Por_Email](https://github.com/MaxJunior2002/Projeto_N8N_Cotacao_Dolar_Por_Email)
    cd Projeto_N8N_Cotacao_Dolar_Por_Email
    ```

2.  **Configurar o Arquivo `.env`:**
    O arquivo `.env` deve estar na raiz do projeto para carregar a variável de ambiente necessária:

    ```ini
    # Variável de Ambiente para o Caminho de Destino do CSV 
    # '/files' é o ponto de montagem dentro do container.
    PASTA_CSV=/files
    ```

3.  **Subir o Serviço Docker:**
    Execute o comando para construir a imagem e iniciar o container. O volume `n8n_data` garante que as credenciais sejam salvas permanentemente.

    ```bash
    docker-compose up -d --build
    ```

4.  **Acesso:** O n8n estará acessível em `http://localhost:5678`.

---

## ⚙️ Configuração de E-mail e Protocolos

As credenciais **NÃO** são salvas no arquivo `.json`. Você deve criá-las na interface do n8n com os **nomes exatos** listados abaixo para que o fluxo funcione.

### 1. Credenciais Necessárias (Nomes Exatos)

| Credencial (Nome no n8n) | Protocolo | Host Correto | Uso no Workflow |
| :--- | :--- | :--- | :--- |
| **IMAP account** | Recebimento (IMAP) | `imap.gmail.com` | **Gatilho de Entrada** (Início do Flow) |
| **SMTP account** | Envio (SMTP) | `smtp.gmail.com` | **Resposta** ao remetente original. |

### 2. Configurações de Hosts Comuns

Ao configurar seu próprio e-mail, utilize a **Senha de Aplicativo** e os Hosts abaixo:

| Provedor/Domínio | Host de Recepção (IMAP) | Host de Envio (SMTP) |
| :--- | :--- | :--- |
| **Gmail** | `imap.gmail.com` | `smtp.gmail.com` |
| **Hotmail/Outlook** | `outlook.office365.com` | `smtp.office365.com` |

### 3. Credenciais de Teste (Para Validação Rápida)

Para teste imediato, utilize estas configurações para criar as credenciais no n8n:

| Campo | Valor |
| :--- | :--- |
| **Email:** | `maxtesteonfly@gmail.com` |
| **Senha de Aplicativo:** | `lkyu cgwo ieof pgox` |

---

## 💾 Armazenamento de Arquivos e Variáveis

### Escolha de Armazenamento

A escolha foi feita pela gravação do arquivo local usando o nó **"Write file to disk"**. Isso cumpre o requisito de **configurabilidade** através da variável de ambiente `PASTA_CSV` e do mapeamento de volume do Docker.

### Configuração da Pasta de Destino

* O **Workflow** utiliza a variável `PASTA_CSV` que, no Docker, aponta para o volume **`/files`**.
* **Expressão no Nó de Gravação:** O nó **"Salvar arquivo no repositório local"** usa a expressão final e corrigida: `{{ $env["PASTA_CSV"] }}/{{ $json.attachments[0].fileName }}`

Para alterar a pasta de destino, edite o volume no `docker-compose.yml` para mapear um novo caminho local (ex: `./Novo_Caminho:/files`).

### Fluxo de E-mail

O e-mail de confirmação é sempre enviado ao **remetente do e-mail recebido**, acessando o endereço através da expressão: `{{ $('Receber email').item.json.from }}`.

---

## 🧪 Teste Final

1.  Crie as credenciais com os nomes exatos.
2.  Ative o workflow.
3.  Envie o arquivo `csv_teste.csv` ou outro arquivo de sua escolha para o e-mail configurado.
4.  Verifique se o arquivo foi salvo na pasta local e se o e-mail de resposta foi recebido com a cotação do dólar.