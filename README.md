# Project execution sequence
#

# Checkout repository
# git


# Go to api-server
docker-compose build
docker-compose run --rm app sh -c "python manage.py makemigrations"
docker-compose up

# Create user:password as  admin@abc.com:Admin123 
docker-compose run --rm app sh -c "python manage.py createsuperuser"

# Use http-command to login or use Postman

# http-command


# Postman
# Install the Postman application
# Import the Postman configuration file in postman-api-client
# Create the initial Extractors using Postman
# Create the initial Documents using Postman
# refer postman-api-client/POSTMAN.md

# Frontend
# We can use the frontend-http-server to have a basic view of documents
# sudo npm install -g http-server
cd frontend-http-server
http-server

# Update the token if hardcoded in main.js:g_user_auth_token
Browser: http://localhost:8080/

# Postgres Reset
# In case we have to reset our database 
# We have the portgres helper commands in postgres-database
