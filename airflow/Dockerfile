FROM apache/airflow:2.9.3-python3.11

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

USER airflow

# Install Python dependencies
COPY --chown=airflow:root ../requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Install Airflow AWS providers
RUN pip install --no-cache-dir \
    apache-airflow-providers-amazon==8.19.0 \
    python-dateutil
