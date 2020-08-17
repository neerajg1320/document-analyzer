# Localhost Installation
# Run following command if venv is not created yet
# https://www.chrisjmendez.com/2017/08/03/installing-multiple-versions-of-python-on-your-mac-using-homebrew/
# We need python version 3.7
# python3 -m venv venv
# pip install -r requirements.txt
# brew install postgresql

# Incase we had to upgrade postfresql
# brew upgrade postgresql
# brew postgresql-upgrade-database
# createdb postgres
# psql postgres

source venv/bin/activate

# https://github.com/daler/pybedtools/issues/259
open /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg
export MACOSX_DEPLOYMENT_TARGET=10.14

# Install pdftotext
brew install pkg-config poppler

# Install dependencies
pip install -r requirements.txt

# Configure postgres
create user postgres with encrypted password 'Postgres123';
create database app;
grant all privileges on database app to postgres;

# Run the server
cd app/
python manage.py runserver

# user: admin@abc.com password: Admin123
python manage.py createsuperuser
