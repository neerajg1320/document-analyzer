import pandas as pd
from io import StringIO


def is_file_extn_excel(file_extn):
    return file_extn == ".xlsx" or file_extn == ".xls" or file_extn == ".csv"


def excel_to_dataframe(file_path):
    df = pd.read_excel(file_path, header=None).rename(columns=lambda x: "Col" + str(x))
    return df


def excel_to_text(file_path):
    df = excel_to_dataframe(file_path)

    buf = StringIO()
    df.to_csv(buf, index=False)

    return buf.getvalue()


def excel_to_json(file_path):
    df = excel_to_dataframe(file_path)

    return df.to_json(orient='records')

