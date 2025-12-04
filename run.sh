#!/bin/bash

# Remova as entradas antigas de /home/o11 de /etc/fstab
sed -i '/home\/o11/d' /etc/fstab
sleep 2

# Adicione novas entradas tmpfs ao arquivo /etc/fstab
cat <<EOL >> /etc/fstab

tmpfs /home/o11/hls tmpfs defaults,noatime,nosuid,nodev,noexec,mode=1777,size=70% 0 0
tmpfs /home/o11/dl tmpfs defaults,noatime,nosuid,nodev,noexec,mode=1777,size=70% 0 0
EOL

# Monte todas as entradas em /etc/fstab
mount -av

# Loop infinito para verificar se o11 está em execução
while true; do
  if ! pgrep "o11v4" > /dev/null; then
    # Iniciando o processo o11
    /home/o11/o11v4 -p 8484 -noramfs -f /usr/bin/ffmpeg -path "/home/o11/" -noautostart -plstreamname "%s [%p]" &
    
    # Aguardar, antes de reiniciar o processo
    sleep 10
  fi
  
  # Aguardar novamente
  sleep 20
done
