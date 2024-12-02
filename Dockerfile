FROM python:3.11-slim-bookworm

RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

COPY requirements.txt .

RUN pip install --no-cache-dir \
    jupyterlab \
    jupyterlab-git \
    httpx==0.27.2 \
    -r requirements.txt

COPY . .

EXPOSE 8888

WORKDIR /workspace/cancer-prediction
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--LabApp.token=''", "--LabApp.password=''", "--allow-root"]