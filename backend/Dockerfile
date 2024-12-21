FROM python:3.9

ARG BACK_DB_HOST
ARG BACK_DB_PORT
ARG POSTGRES_USER
ARG POSTGRES_PASSWORD
ARG POSTGRES_DB

ENV BACK_DB_HOST=${BACK_DB_HOST}
ENV BACK_DB_PORT=${BACK_DB_PORT}
ENV POSTGRES_USER=${POSTGRES_USER}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
ENV POSTGRES_DB=${POSTGRES_DB}

COPY ./ /app

WORKDIR /app

RUN apt update && apt install python3-dev libpq-dev -y &&\
    python3 -m venv env &&\
    python3 -m pip install --upgrade pip &&\
    pip install -r requirements.txt

EXPOSE 8000

CMD python3 /app/manage.py runserver 0:8000