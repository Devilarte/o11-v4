FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    openssl \
    python3 \
    python3-pip \
    ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/o11

WORKDIR /home/o11

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g pm2 \
    && npm install express

RUN pip3 install flask

RUN mkdir -p \
    hls/live \
    hls/replay \
    dl/tmp \
    scripts \
    logs \
    rec && \
    chmod -R 755 \
    hls \
    dl \
    scripts \
    logs \
    rec

COPY server.js server.py run.sh o11.cfg o11v4 lic.cr /home/o11/

# Garantir que as quebras de linha Unix sejam usadas para run.sh
RUN sed -i 's/\r$//' /home/o11/run.sh

RUN chmod 755 /home/o11/run.sh

RUN chmod 755 /home/o11/o11v4

RUN chmod 755 /home/o11/lic.cr

RUN mkdir -p /home/o11/certs && \
    openssl req -x509 -newkey rsa:2048 -keyout /home/o11/certs/key.pem -out /home/o11/certs/cert.pem -days 365 -nodes -subj "/CN=localhost"

RUN cat <<'EOF' > /home/o11/start.sh
#!/bin/bash
# Checando se IP_ADDRESS foi fornecido
if [ -z "$IP_ADDRESS" ]; then
    echo "Erro: A variável IP_ADDRESS não foi definida."
    exit 1
fi

# Atualizar IP nos arquivos do servidor
sed -i "s/const ipAddress = ''/const ipAddress = '$IP_ADDRESS'/g" /home/o11/server.js
sed -i "s/IP_ADDRESS = \"\"/IP_ADDRESS = \"$IP_ADDRESS\"/g" /home/o11/server.py

# Crie os diretórios necessários para run.sh
mkdir -p /home/o11/hls /home/o11/dl

# Opções para iniciar o servidor
if [ "$SERVER_TYPE" = "python" ]; then
  pm2 start server.py --name licserver --interpreter python3
else
  pm2 start server.js --name licserver --silent
fi

pm2 save

nohup ./run.sh > /dev/null 2>&1 &

pm2 logs
EOF

# Garantir que as quebras de linha Unix sejam usadas para start.sh
RUN sed -i 's/\r$//' /home/o11/start.sh

RUN chmod 755 /home/o11/start.sh

EXPOSE 80 443 5454 8484

ENV SERVER_TYPE=nodejs
ENV IP_ADDRESS=""

CMD ["bash", "/home/o11/start.sh"]
