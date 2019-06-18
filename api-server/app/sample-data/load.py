import hjson

file_path = "transactions.json"
file = open(file_path)

ord_dict = hjson.load(file)

import json
json.dumps(ord_dict)

import pandas as pd
df = pd.DataFrame(ord_dict)
