FROM apache/airflow:2.4.1
USER root
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
         vim \
         gcc \
         g++ \
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

USER airflow

COPY requirements/base.txt base.txt
COPY requirements/airflow.txt airflow.txt

RUN pip install --upgrade pip
RUN pip install -r base.txt -c airflow.txt

ENV PYTHONPATH='$PYTHONPATH:/opt/airflow/dags'
