# Start the server
cd api-server
source venv3/bin/activate
cd app
python manage.py runserver

# Start the frontend
cd frontend-vue
npm install
npm run serve
