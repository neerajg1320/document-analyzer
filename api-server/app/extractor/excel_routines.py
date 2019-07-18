import pandas as pd
from io import StringIO


def is_file_extn_excel(file_extn):
    return file_extn == ".xlsx"


def excel_to_text(file_path):
    df = pd.read_excel(file_path, header=None)

    buf = StringIO()
    df.to_csv(buf, index=False)

    return buf.getvalue()


def excel_to_json(file_path):
    df = pd.read_excel(file_path, header=None)

    return df.to_json(orient='records')

