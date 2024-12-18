FROM python:3.9

ARG BACK_DB_NAME
ARG BACK_DB_USER
ARG BACK_USER_PASSWORD
ARG BACK_DB_HOST
ARG BACK_DB_PORT

ENV BACK_DB_NAME=${BACK_DB_NAME}
ENV BACK_DB_USER=${BACK_DB_USER}
ENV BACK_USER_PASSWORD=${BACK_USER_PASSWORD}
ENV BACK_DB_HOST=${BACK_DB_HOST}
ENV BACK_DB_PORT=${BACK_DB_PORT}

COPY ./ /app

WORKDIR /app

RUN apt update && apt install python3-dev libpq-dev -y &&\
    python3 -m venv env &&\
    python3 -m pip install --upgrade pip &&\
    pip install -r requirements.txt && chmod +x /app/entrypoint.sh

EXPOSE 8000

CMD /app/entrypoint.sh