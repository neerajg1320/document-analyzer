from pyspark import SparkContext
from pyspark.sql import Row
from pyspark.sql import SQLContext
from pyspark import SparkFiles


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


def infer_csv_schema(sc):
    # Basic Operation with Pyspark

    url = "https://raw.githubusercontent.com/guru99-edu/R-Programming/master/adult_data.csv"
    sc.addFile(url)
    sqlContext = SQLContext(sc)
    df = sqlContext.read.csv(SparkFiles.get("adult_data.csv"),
                             header=True,
                             inferSchema=True)
    df.printSchema()

    return df


if __name__ == '__main__':
    # Get SparkContext
    sc = SparkContext()

    # square_nums(sc)
    # infer_schema(sc)
    df = infer_csv_schema(sc)
    df.show(5, truncate=False)

