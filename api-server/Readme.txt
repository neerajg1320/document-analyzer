brew install poppler

python3 -m venv venv3
pip install -r requirements.txt

brew install postgresql
pg_ctl -D /usr/local/var/postgres start
psql postgres

# Following commands are run on postgres shell
create user postgres with encrypted password 'Postgres123';
create database app;
grant all privileges on database app to postgres;
create database docminer;
grant all privileges on database docminer to postgres;

cd app/
python manage.py runserver
