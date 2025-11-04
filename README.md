# N8N + Ngrok Setup

Setup completo do N8N com tunelamento Ngrok, PostgreSQL e Redis em modo fila.

## 🚀 Início Rápido

1. **Configure as variáveis de ambiente:**
   ```bash
   cp .env.example .env
   ```
   
2. **Edite o arquivo `.env`** e adicione seu token do Ngrok:
   ```
   NGROK_AUTHTOKEN=seu_token_aqui
   ```

3. **Inicie os containers:**
   ```bash
   docker-compose up -d --build
   ```

4. **Acesse:**
   - N8N: O container ngrok criará uma URL pública (verifique os logs)
   - Ngrok Dashboard: http://localhost:4040
   - N8N Local: http://localhost:5678

## 🔐 Segurança

⚠️ **IMPORTANTE:** 
- O arquivo `.env` contém dados sensíveis e **NUNCA** deve ser commitado no Git
- O `.gitignore` já está configurado para ignorar este arquivo
- Use `.env.example` como referência para novos ambientes

## 📝 Variáveis de Ambiente

### NGROK_AUTHTOKEN
Seu token de autenticação do Ngrok. Obtenha em: https://dashboard.ngrok.com/get-started/your-authtoken

### Credenciais PostgreSQL
- `POSTGRES_USER`: Usuário do banco (padrão: postgres)
- `POSTGRES_PASSWORD`: Senha do banco (padrão: postgres)
- `POSTGRES_DB`: Nome do banco (padrão: n8n-db)

## 🛠️ Comandos Úteis

```bash
# Ver logs do ngrok (incluindo URL pública)
docker logs n8n-ngrok-1

# Ver logs do n8n
docker logs n8n-n8n-1

# Reiniciar todos os serviços
docker-compose restart

# Parar todos os serviços
docker-compose down

# Parar e remover volumes (CUIDADO: remove dados)
docker-compose down -v
```

## 📦 Serviços

- **n8n**: Aplicação principal (porta 5678)
- **n8n-worker**: Worker para processamento de execuções
- **n8n-webhook**: Handler dedicado para webhooks
- **postgresql**: Banco de dados com suporte a pgvector
- **redis**: Cache e gerenciamento de filas
- **ngrok**: Túnel público para o N8N
