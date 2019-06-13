# document-analyzer
The Document Analyzer Project 


# To Run Tests:
docker-compose run --rm app sh -c "python manage.py test && flake8"

# To create superuser: admin@abc.com:Admin123
docker-compose run --rm app sh -c "python manage.py createsuperuser"
 
# In case of database inconsistency
docker-compose run --rm app sh -c "python manage.py makemigrations"

