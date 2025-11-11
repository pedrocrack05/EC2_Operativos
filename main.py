from fastapi import FastAPI, Request
from pydantic import BaseModel
import boto3
import json
from datetime import datetime
from dotenv import load_dotenv
import os

load_dotenv()

AWS_ACCESS_KEY = os.getenv("AWS_ACCESS_KEY")
AWS_SECRET_KEY = os.getenv("AWS_SECRET_KEY")
AWS_S3_BUCKET_NAME = os.getenv("AWS_S3_BUCKET_NAME")
AWS_REGION = os.getenv("AWS_REGION", "us-east-1")

s3_client = boto3.client(
        service_name="s3",
        region_name=AWS_REGION,
        aws_access_key_id=AWS_ACCESS_KEY,
        aws_secret_access_key=AWS_SECRET_KEY
    )

app = FastAPI()

# Endpoint to insert data into S3 bucket
@app.post("/insert")
async def insert(request: Request):
    
    datos = await request.json()

    now_str = datetime.now().strftime("%Y%m%d-%H%M%S-%f")
    key = f"{now_str}.json"

    s3_client.put_object(
        Bucket=AWS_S3_BUCKET_NAME,
        Key=key,
        Body=json.dumps(datos)
    )

    resp = s3_client.list_objects_v2(Bucket=AWS_S3_BUCKET_NAME)
    count = resp.get("KeyCount", 0)

    return {"count": count}
