from pyspark import SparkContext
from pyspark.sql import Row
from pyspark.sql import SQLContext
from pyspark import SparkFiles

from pyspark.sql.types import *


def square_nums(sc):
    # Create an array of numbers
    nums = sc.parallelize([1, 2, 3, 4])
    # Square this array of numbers, Spark contributes in parallelization
    squared = nums.map(lambda x: x * x).collect()
    for num in squared:
        print('%i' % (num))


def infer_schema(sc):
    list_p = [('John', 19), ('Smith', 29), ('Adam', 35), ('Henry', 50)]
    rdd = sc.parallelize(list_p)
    ppl = rdd.map(lambda x: Row(name=x[0], age=int(x[1])))

    sqlContext = SQLContext(sc)
    DF_ppl = sqlContext.createDataFrame(ppl)
    DF_ppl.printSchema()

    return DF_ppl


def read_csv_with_schema(sc, flagInferSchema):
    # Basic Operation with Pyspark

    # url = "https://raw.githubusercontent.com/guru99-edu/R-Programming/master/adult_data.csv"
    url = "./adult_data.csv"
    sc.addFile(url)
    sqlContext = SQLContext(sc)
    df = sqlContext.read.csv(SparkFiles.get("adult_data.csv"),
                             header=True,
                             inferSchema=flagInferSchema)

    return df


# A custom function to convert the data type of DataFrame columns
def convertColumn(df, names, newType):
    for name in names:
        df = df.withColumn(name, df[name].cast(newType))
    return df


def demo_spark_sql_dataframe(sc):
    # square_nums(sc)
    # infer_schema(sc)
    df = read_csv_with_schema(sc, False)
    print(type(df))
    df.printSchema()
    df.show(5, truncate=False)
    # List of float features
    FLOAT_FEATURES = ['age', 'fnlwgt', 'capital-gain', 'educational-num', 'capital-loss', 'hours-per-week']
    df = convertColumn(df, FLOAT_FEATURES, FloatType())
    df.printSchema()
    df.select('age', 'fnlwgt').show(5)
    # Groupby and sort
    df.groupBy("education").count().sort("count", ascending=True).show()
    # df.describe().show()
    df.describe('capital-gain').show()
    df.crosstab('age', 'income').sort("age_income").show()
    print("People above 40: ", df.filter(df.age > 40).count())
    # Group by
    df.groupby('marital-status').agg({'capital-gain': 'mean'}).show()


if __name__ == '__main__':
    # Get SparkContext
    sc = SparkContext()

    demo_spark_sql_dataframe(sc)
