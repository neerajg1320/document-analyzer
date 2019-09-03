pg_ctl -D /usr/local/var/postgres/ start

source ../venv/bin/activate
python manage.py runserver
