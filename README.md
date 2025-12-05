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

As credenciais **NÃO** são salvas no arquivo `.json` por segurança. Você deve criá-las na interface do n8n com os **nomes exatos** listados abaixo.

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

Foi escolhida a gravação do arquivo local usando o nó **"Write file to disk"**. Isso cumpre o requisito de **configurabilidade** através da variável de ambiente `PASTA_CSV` e do mapeamento de volume do Docker.

### Configuração da Pasta de Destino

* O **Workflow** utiliza a variável `PASTA_CSV` que, no Docker, aponta para o volume **`/files`**.
* **Expressão no Nó de Gravação:** O nó **"Salvar arquivo no repositório local"** usa a expressão: `{{ $env["PASTA_CSV"] }}/{{ $json.attachments[0].fileName }}`

Para alterar a pasta de destino (Ex: para a pasta `ArquivosOnfly2` em seu host), edite o mapeamento de volume no seu `docker-compose.yml` e reinicie o Docker.

### Fluxo de E-mail

O e-mail de confirmação é sempre enviado ao **remetente do e-mail recebido**, acessando o endereço através da expressão: `{{ $node["Receber email"].json.from.emailAddress }}`.

---

## 🧪 Teste Final: Execução Completa do Workflow

Para validar a funcionalidade do projeto, siga os passos abaixo:

### Passo 1: Preparação do n8n (Importação)

1.  **Acesse a Interface do n8n:** Abra `http://localhost:5678`.
2.  **Importar o Workflow:**
    * Crie um novo workflow vazio.
    * Clique no menu de **três pontos ( ... )** e selecione **"Import from File..."**.
    * Escolha o arquivo **`TesteOnfly_MaximilianoAugusto.json`**.
3.  **Crie as Credenciais:** Na seção "Credentials", crie a **`IMAP account`** e a **`SMTP account`** usando os nomes e as configurações de teste fornecidas.

### Passo 2: Execução do Teste

1.  **Prepare o E-mail de Teste:** Use qualquer outra conta de e-mail (simulando o remetente original).
2.  **Anexe o CSV:** Anexe o arquivo **`csv_teste.csv`** (ou qualquer arquivo CSV).
3.  **Endereço de Destino:** Envie o e-mail para o endereço configurado no seu Trigger (ex: `maxtesteonfly@gmail.com`).
4.  **Ativar o Workflow:** Mude a chave seletora de **Inactive** para **Active** no canto superior direito.

### Passo 3: Verificação dos Resultados

1.  **Verificação do Arquivo Salvo (Gravação):**
    * Abra o terminal e acesse o terminal do seu container: `docker exec -it testeonfly-n8n-1 sh`
    * Verifique se o arquivo foi salvo no ponto de montagem: `ls -la /files`
    * O arquivo `csv_teste.csv` deve estar listado.
2.  **Verificação da Resposta (Confirmação):**
    * Verifique a caixa de entrada do **Remetente Original** (a conta de e-mail usada para enviar o teste).
    * Você deve receber um e-mail de confirmação (enviado pelo SMTP account) contendo a cotação USD→BRL.
