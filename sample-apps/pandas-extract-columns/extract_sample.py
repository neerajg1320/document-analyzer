# https://stackoverflow.com/questions/46928636/pandas-split-list-into-columns-with-regex

import pandas as pd

adict = {}
adict['content'] = ["01/09/15, 10:07 - message1", "01/09/15, 10:32 - message2", "01/09/15, 10:44 - message3"]
print(adict)

df = pd.DataFrame(adict)
print(df)

new_df = df['content'].str.extract('(?P<date>[\s\S]+) - (?P<message>[\s\S]+)', expand=True)
print(new_df)
