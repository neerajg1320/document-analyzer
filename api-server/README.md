# document-analyzer
The Document Analyzer Project 

# Start the api-server
cd api-server

# On a New Machine we need to Install docker and do following steps
docker-compose build 
docker-compose run --rm app sh -c "python manage.py makemigrations core"

# Create superuser admin@abc.com:Admin123
docker-compose run --rm app sh -c "python manage.py createsuperuser"
docker-compose up


# To run a shell on the container
docker exec -it <api-server_app_1> sh

# To find container name
docker ps 


# Alert: docker-compose down will delete the virtual machines
# Alert: Changing the directory will delete the virtual machines

# To Run Tests:
docker-compose run --rm app sh -c "python manage.py test && flake8"

# To create superuser: admin@abc.com:Admin123
docker-compose run --rm app sh -c "python manage.py createsuperuser"
 
# In case of database inconsistency
docker-compose run --rm app sh -c "python manage.py makemigrations"


# Django delete all objects in a model
# In database terms this would be clearing a table
docker-compose run --rm app sh -c "python manage.py shell"
Model.objects.all().delete()

# Drop Table
cursor = connection.cursor()
table_name = self.model._meta.db_table
sql = "DROP TABLE %s;" % (table_name, )
cursor.execute(sql)

# Python migrations reset
# https://simpleisbetterthancomplex.com/tutorial/2016/07/26/how-to-reset-migrations.html
python manage.py showmigrations

find . -path "*/migrations/*.py" -not -name "__init__.py" -delete
find . -path "*/migrations/*.pyc"  -delete   
#
python -m django --version
pip install --upgrade --force-reinstall  Django==2.1.9

python manage.py migrate --fake core zero
python manage.py makemigrations

#If the database already exists
python manage.py migrate --fake


# Install pdftotext
brew install pkg-config poppler