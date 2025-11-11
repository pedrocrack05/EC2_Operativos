# **Paso a paso**

## **Crear y activar entorno virtual**
python3 -m venv venv
source venv/bin/activate

## **Instalar dependencias**
pip install -r requirements.txt

## **Ejecutar servidor FastAPI**
uvicorn main:app --host 0.0.0.0 --port 8000


**Y listo profe, podes probar haciendo un POST /insert. Claramente tenes que configurar tu .env pero eso esta igual en el .env.example**