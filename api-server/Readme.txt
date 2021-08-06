# Install Poppler
brew install poppler

# Install Postgres
brew install postgresql
pg_ctl -D /usr/local/var/postgres start
psql postgres

# Following commands are run on postgres shell
create user postgres with encrypted password 'Postgres123';
create database app;
grant all privileges on database app to postgres;
create database docminer;
grant all privileges on database docminer to postgres;

# Install python if needed 

# Create python virtual environment
python3 -m venv venv3
source venv3/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# grpcio issue:
# https://github.com/grpc/grpc/issues/24677
pip install wheel && GRPC_BUILD_WITH_BORING_SSL_ASM="" GRPC_PYTHON_BUILD_SYSTEM_RE2=true GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=true GRPC_PYTHON_BUILD_SYSTEM_ZLIB=true pip install grpcio

python manage.py makemigrations core
python manage.py migrate


cd app/
# If running for first time
python manage.py makemigrations core
python manage.py migrate

python manage.py runserver
