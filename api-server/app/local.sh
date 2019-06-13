# Install postgres on mac and create user postgres
# https://medium.com/@viviennediegoencarnacion/getting-started-with-postgresql-on-mac-e6a5f48ee399
# Run the following commands on command line
#
createdb app
psql postgres
  CREATE ROLE postgres WITH LOGIN PASSWORD 'Postgres123';
  ALTER ROLE postgres CREATEDB;
  \q

psql postgres -U postgres


# Add host mapping db to localhost
# Add following row to /etc/hosts file
# 127.0.0.1       db


# Setup django application
pip3 install virtualenv
virtualenv env
source venv/bin/activate
python3 manage.py makemigrations
python3 manage.py migrate

python3 manage.py createsuperuser
# User: admin@abc.com
# Password: Admin123

# Run django application
python3 manage.py runserver 0.0.0.0:8000
