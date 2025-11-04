#!/bin/sh
# ./ngrok-entrypoint.sh

set -e

# Inicia o ngrok em background
ngrok start --all --config /etc/ngrok.yml --log=stdout &

# Espera o ngrok e a API (porta 4040) subirem
echo "Aguardando API do Ngrok..."
sleep 3

# Busca a URL pública pela API do Ngrok e salva no volume
# Usamos grep/sed para não depender do 'jq'
echo "Buscando URL do Ngrok..."
URL=$(curl -s http://localhost:4040/api/tunnels | grep -o 'https://[^\"]*.ngrok-free.app')

if [ -z "$URL" ]; then
  echo "Falha ao obter URL do Ngrok!"
  curl -s http://localhost:4040/api/tunnels # Mostra a saída para debug
  exit 1
fi

# Salva a URL no volume compartilhado
echo $URL > /ngrok-data/ngrok_url.txt
echo "URL do Ngrok ($URL) salva em /ngrok-data/ngrok_url.txt"

# Mantém o script rodando (esperando o processo ngrok em background)
wait
