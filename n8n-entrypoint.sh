#!/bin/sh
# ./n8n-entrypoint.sh

set -e

URL_FILE="/ngrok-data/ngrok_url.txt"

# Espera o arquivo de URL ser criado pelo container do ngrok
echo "Aguardando URL do Ngrok em $URL_FILE..."
while [ ! -f "$URL_FILE" ]; do
  sleep 2
done

# Lê a URL do arquivo
export NGROK_URL=$(cat $URL_FILE)

echo "========================================="
echo "URL pública do Ngrok: $NGROK_URL"
echo "========================================="

# Configura as variáveis de ambiente que o n8n precisa
export N8N_HOST=$NGROK_URL
export WEBHOOK_URL=$NGROK_URL
export WEBHOOK_TUNNEL_URL=$NGROK_URL

# Executa o comando padrão do n8n (que é 'n8n start')
echo "Iniciando n8n com URL: $NGROK_URL"
exec n8n
