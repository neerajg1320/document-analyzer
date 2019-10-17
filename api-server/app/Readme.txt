pg_ctl -D /usr/local/var/postgres/ start

# If running for first time
python manage.py makemigrations core
python manage.py migrate

source ../venv/bin/activate
python manage.py runserver
