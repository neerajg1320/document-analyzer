from snowflake.sqlalchemy import URL
from sqlalchemy import create_engine

import numpy as np
import pandas as pd

# Ref: https://docs.snowflake.net/manuals/user-guide/sqlalchemy.html
engine = create_engine(URL(
    user='finball',
    password='Finball@2018',
    account='yw56161',
    database='Trades',
    schema='public',
    warehouse='compute_wh',
))

try:
    connection = engine.connect()
    results = connection.execute('select current_version()').fetchone()
    print(results[0])

    df = pd.read_sql_query("SELECT * FROM USStocks", engine)
    print(df)
finally:
    connection.close()
    engine.dispose()
