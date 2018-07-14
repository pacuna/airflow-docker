FROM ubuntu:18.04
MAINTAINER Pablo Acuña <pabloacuna88@gmail.com>
RUN apt-get update && apt-get install -y \
  python \
  python-pip \
  postgresql-client
RUN pip install "apache-airflow[postgres,celery]" celery redis
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN addgroup --gid 1000 airflow
RUN adduser --uid 1000 --gid 1000 --disabled-password --gecos "Airflow" airflow
RUN usermod -L airflow
RUN mkdir -p /home/airflow
WORKDIR /home/airflow
COPY wait-for-postgres.sh wait-for-postgres.sh
COPY wait-for-migrations.sh wait-for-migrations.sh
RUN chown -R airflow:airflow /home/airflow
USER airflow
ENV AIRFLOW_HOME=/home/airflow
