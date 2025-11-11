#!/bin/bash

# === CONFIGURACIÓN AUTOMÁTICA FASTAPI EN EC2 ===
# Ejecutar como usuario ubuntu (no root)
# -----------------------------------------------

# 1. Actualizar sistema e instalar dependencias
sudo apt update -y
sudo apt install -y python3 python3-venv git

# 2. Descargar o actualizar el repositorio
cd /home/ubuntu
if [ ! -d "ec2-fastapi-s3" ]; then
  git clone https://github.com/TU_USUARIO/ec2-fastapi-s3.git
else
  cd ec2-fastapi-s3 && git pull
fi

cd /home/ubuntu/ec2-fastapi-s3

# 3. Crear entorno virtual si no existe
if [ ! -d "venv" ]; then
  python3 -m venv venv
fi

source venv/bin/activate

# 4. Instalar dependencias
pip install -r requirements.txt

# 5. Verificar que el archivo .env exista
if [ ! -f ".env" ]; then
  echo "⚠️  El archivo .env no existe. Créalo antes de iniciar el servicio."
  exit 1
fi

# 6. Copiar el servicio systemd y habilitarlo
sudo cp fastapi.srv /etc/systemd/system/fastapi.service
sudo systemctl daemon-reload
sudo systemctl enable fastapi.service
sudo systemctl restart fastapi.service

# 7. Confirmar estado
sleep 2
sudo systemctl status fastapi.service --no-pager

echo "✅ FastAPI desplegado y corriendo con variables de entorno desde .env"
