# document-analyzer
The Document Analyzer Project 

# On a New Machine we need to Install docker and do following steps
docker-compose build 
docker-compose run --rm app sh -c "python manage.py makemigrations core"

# Create superuser admin@abc.com:Admin123
docker-compose run --rm app sh -c "python manage.py createsuperuser"
docker-compose up


# Alert: docker-compose down will delete the virtual machines
# Alert: Changing the directory will delete the virtual machines

# To Run Tests:
docker-compose run --rm app sh -c "python manage.py test && flake8"

# To create superuser: admin@abc.com:Admin123
docker-compose run --rm app sh -c "python manage.py createsuperuser"
 
# In case of database inconsistency
docker-compose run --rm app sh -c "python manage.py makemigrations"

