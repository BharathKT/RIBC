#!/bin/bash
/bin/python3.6 manage.py makemigrations app
/bin/python3.6 manage.py migrate
/bin/python3.6 manage.py runserver 0.0.0.0:8000