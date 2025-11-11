
sudo apt update -y
sudo apt install -y python3 python3-venv git

cd /home/ubuntu
if [ ! -d "ec2-fastapi-s3" ]; then
  git clone https://github.com/TU_USUARIO/ec2-fastapi-s3.git
else
  cd ec2-fastapi-s3 && git pull
fi

cd /home/ubuntu/ec2-fastapi-s3

if [ ! -d "venv" ]; then
  python3 -m venv venv
fi

source venv/bin/activate

pip install -r requirements.txt

if [ ! -f ".env" ]; then
  echo " El archivo .env no existe."
  exit 1
fi

sudo cp fastapi.srv /etc/systemd/system/fastapi.service
sudo systemctl daemon-reload
sudo systemctl enable fastapi.service
sudo systemctl restart fastapi.service

sleep 2
sudo systemctl status fastapi.service --no-pager

echo "FastAPI desplegado y corriendo con variables de entorno desde .env"
