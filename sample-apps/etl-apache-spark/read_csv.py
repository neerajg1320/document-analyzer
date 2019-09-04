from pyspark.sql import SparkSession
from pyspark.sql import SQLContext


def read_small_csv_files():
    data_file = './data*.csv'
    sdfData = scSpark.read.csv(data_file, header=True, sep=",").cache()
    print('Total Records = {}'.format(sdfData.count()))
    sdfData.show()


def read_csv_file():
    data_file = './supermarket_sales.csv'
    sdfData = scSpark.read.csv(data_file, header=True, sep=",").cache()
    return sdfData


def transform_data(sdfData):
    gender = sdfData.groupBy('Gender').count()
    print(gender.show())

    sdfData.registerTempTable("sales")
    output =  scSpark.sql('SELECT * from sales')
    output.show()

    output = scSpark.sql('SELECT * from sales WHERE `Unit Price` < 15 AND Quantity < 10')
    output.show()

    output = scSpark.sql('SELECT COUNT(*) as total, City from sales GROUP BY City')
    output.show()

    #  .coalesce(1) is to create a single file
    # output.coalesce(1).write.format('json').save('filtered.json')

    # Following worked
    url = """jdbc:postgresql://localhost/app?user=postgres&password=Postgres123"""
    output.write\
        .format('jdbc') \
        .option("url", url) \
        .option("dbtable", "city")\
        .mode('overwrite')\
        .save()


def load_from_postgres():
    url = """jdbc:postgresql://localhost/app?user=postgres&password=Postgres123"""
    df1 = scSpark.read\
        .format("jdbc")\
        .option("url", url)\
        .option("query", "select * from trades")\
        .load()

    df1.show()


if __name__ == '__main__':
    #  The .config has been added for mysql support
    scSpark = SparkSession \
        .builder \
        .appName("reading csv") \
        .config("spark.driver.extraClassPath", "/usr/local/spark/postgresql-42.2.6.jar") \
        .getOrCreate()

    # read_small_csv_files()

    df1 = read_csv_file()

    transform_data(df1)

    load_from_postgres()
