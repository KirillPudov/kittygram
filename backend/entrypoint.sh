#!/bin/sh
python3 /app/manage.py migrate

python3 /app/manage.py runserver 0:8000