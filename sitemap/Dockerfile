FROM python:3.12-slim

WORKDIR /app

# Install deps first (layer cache — only rebuilds when requirements change)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

ENV MOUNTED_OUTPUT_PATH=/opt/output
VOLUME ["/opt/output"]

CMD ["python", "app.py"]
