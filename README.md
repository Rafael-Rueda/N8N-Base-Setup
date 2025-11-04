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

## 🔄 Gerenciamento de URL do Ngrok

### Problema Resolvido
Quando os containers são pausados e reiniciados, o Ngrok gera uma nova URL. Este setup resolve isso automaticamente:

1. **Healthcheck do Ngrok**: Verifica se o túnel está ativo
2. **Detecção de Mudança**: Script detecta quando a URL muda
3. **Restart Automático**: Containers N8N reiniciam automaticamente quando a URL muda
4. **Volume Compartilhado**: URL é compartilhada entre containers via volume

### Como Funciona
- O container `ngrok` detecta mudanças na URL ao iniciar
- Quando detecta uma mudança, cria uma flag indicando isso
- Os containers `n8n`, `n8n-worker` e `n8n-webhook` dependem do ngrok com `restart: true`
- Docker reinicia automaticamente os containers N8N quando o ngrok muda de estado (nova URL)
- Os scripts de entrypoint garantem que os containers N8N sempre usem a URL mais recente

### Logs Importantes
Após reiniciar, verifique os logs para confirmar a nova URL:
```bash
# Ver logs do ngrok (mostra se URL mudou)
docker logs n8n-ngrok-1

# Ver logs do n8n (mostra qual URL está usando)
docker logs n8n-n8n-1
```

## 🛠️ Comandos Úteis

```bash
# Ver logs do ngrok (incluindo URL pública)
docker logs n8n-ngrok-1

# Ver logs do n8n
docker logs n8n-n8n-1

# Reiniciar todos os serviços (URL será atualizada automaticamente)
docker-compose restart

# Parar todos os serviços
docker-compose down

# Parar e remover volumes (CUIDADO: remove dados)
docker-compose down -v

# Ver URL atual do Ngrok
docker exec n8n-ngrok-1 cat /ngrok-data/ngrok_url.txt
```

## 📦 Serviços

- **n8n**: Aplicação principal (porta 5678)
- **n8n-worker**: Worker para processamento de execuções
- **n8n-webhook**: Handler dedicado para webhooks
- **postgresql**: Banco de dados com suporte a pgvector
- **redis**: Cache e gerenciamento de filas
- **ngrok**: Túnel público para o N8N
