FROM python:latest

WORKDIR /app

RUN apt-get update && \
    apt-get install -y curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L https://dl.filippo.io/mkcert/latest?for=linux/amd64 \
      -o /usr/local/bin/mkcert && \
    chmod +x /usr/local/bin/mkcert

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

EXPOSE 5000

ENTRYPOINT ["./entrypoint.sh"]