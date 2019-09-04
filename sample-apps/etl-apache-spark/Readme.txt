spark-shell --driver-class-path postgresql-42.2.6.jar --jars postgresql-42.2.6.jar

val url = "jdbc:postgresql://localhost/app?user=postgres&password=Postgres123"

val df1 = spark.read.format("jdbc").option("url", url).option("query", "select * from trades").load()

df1.show()

# Also we can copy drivers to /usr/local/spark
cp mysql-connector-java-8.0.16/mysql-connector-java-8.0.16.jar /usr/local/spark
cp postgresql-42.2.6.jar /usr/local/spark
