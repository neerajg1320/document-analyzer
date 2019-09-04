source ../python-venv/bin/activate

export AIRFLOW_HOME=$PWD
echo $AIRFLOW_HOME

airflow initdb
airflow scheduler
airflow webserver -p 9090
