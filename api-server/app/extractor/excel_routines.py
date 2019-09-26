import pandas as pd
from io import StringIO
from inspect import currentframe, getframeinfo


def is_file_extn_excel(file_extn):
    return file_extn == ".xlsx" or file_extn == ".xls" or file_extn == ".csv"


def excel_to_dataframe(file_path, header=None):
    frameinfo = getframeinfo(currentframe())
    print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), "header:", header)

    df = pd.read_excel(file_path, header=header)

    frameinfo = getframeinfo(currentframe())
    print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), df.iloc[0], df.columns)

    if header is None:
        df = df.rename(columns=lambda x: "Col" + str(x))

    # Replace np.NaN with '' empty string
    df.fillna('', inplace=True)

    return df


def excel_to_text(file_path, header=None):
    df = excel_to_dataframe(file_path, header=header)

    buf = StringIO()
    df.to_csv(buf, index=False)

    return buf.getvalue()


def excel_to_json(file_path, header=None):
    df = excel_to_dataframe(file_path, header=header)

    return df.to_json(orient='records')

