# Install Poppler
brew install poppler
# In case we need a specific version. We have found it working with 0.81.0 and 0.90.1
# pdftotext 2.1.5 works with pdftotext -v 0.90.1
# pdftotext 2.1.2 works with pdftotext -v 0.81.0 
# Use link format: https://poppler.freedesktop.org/poppler-0.81.0.tar.xz

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


# Save Database
pd_dump app > postgres_database_dump.sql

# Restore Database
psql postgres -c "create database app owner postgres"
psql app < postgres_database_dump.sql


# Container instructions
# https://gist.github.com/Dayjo/618794d4ff37bb82ddfb02c63b450a81
wget https://poppler.freedesktop.org/poppler-0.81.0.tar.xz

# Get linux release
cat /etc/issue


# https://snapcraft.io/install/cmake/debian
sudo apt update
sudo apt install snapd
sudo snap install cmake --classic


# https://websiteforstudents.com/installing-the-latest-python-3-7-on-ubuntu-16-04-18-04/
apt update
apt install software-properties-common
add-apt-repository ppa:deadsnakes/ppa
apt update
apt install python3.7