# https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.aggregate.html

# Make sure anaconda python is running
python -i basic.py 

# Then on the command prompt use 
df.agg(['sum', 'min'])

# Difference aggregation per column
df.agg({'A' : ['sum', 'min'], 'B' : ['min', 'max']})

# Aggregate over columns
df.agg("mean", axis="columns")
