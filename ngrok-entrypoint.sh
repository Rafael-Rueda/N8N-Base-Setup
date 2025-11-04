#!/bin/sh
# ./ngrok-entrypoint.sh

set -e

URL_FILE="/ngrok-data/ngrok_url.txt"
URL_CHANGED_FLAG="/ngrok-data/url_changed.flag"

# Inicia o ngrok em background
ngrok start --all --config /etc/ngrok.yml --log=stdout &

# Espera o ngrok e a API (porta 4040) subirem
echo "Aguardando API do Ngrok..."
sleep 3

# Busca a URL pública pela API do Ngrok
echo "Buscando URL do Ngrok..."
URL=$(curl -s http://localhost:4040/api/tunnels | grep -o 'https://[^\"]*.ngrok-free.app')

if [ -z "$URL" ]; then
  echo "Falha ao obter URL do Ngrok!"
  curl -s http://localhost:4040/api/tunnels # Mostra a saída para debug
  exit 1
fi

# Verifica se a URL mudou
OLD_URL=""
if [ -f "$URL_FILE" ]; then
  OLD_URL=$(cat "$URL_FILE")
fi

if [ "$URL" != "$OLD_URL" ]; then
  echo "========================================="
  echo "URL DO NGROK MUDOU!"
  echo "URL antiga: $OLD_URL"
  echo "URL nova: $URL"
  echo "========================================="
  
  # Salva a nova URL
  echo "$URL" > "$URL_FILE"
  
  # Cria flag indicando que a URL mudou
  # Isso força o Docker a reiniciar os containers n8n via depends_on com restart: true
  echo "$(date -Iseconds)" > "$URL_CHANGED_FLAG"
  
  echo "URL do Ngrok ($URL) salva em $URL_FILE"
  echo "Flag de mudança criada em $URL_CHANGED_FLAG"
else
  echo "URL do Ngrok não mudou: $URL"
  # Remove flag se existir (para casos de restart sem mudança de URL)
  rm -f "$URL_CHANGED_FLAG"
fi

# Mantém o script rodando (esperando o processo ngrok em background)
wait
