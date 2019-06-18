# Localhost Installation
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
