#!/bin/sh
# wait-for-postgres.sh
apt-get update
apt install -y netcat
while ! nc -z db 5432; do sleep 1; done;
  echo "postgres available"

  echo "Attempting to apply migrations"
  python manage.py migrate

  echo "Attempting to create superuser"
  python manage.py shell -c "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'admin')"

  echo "Attempting to start server"
  python manage.py runserver 0.0.0.0:8000
  ;
# ./run-smth-else;
