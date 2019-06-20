import pandas as pd
from datetime import datetime, timezone


def df_map_columns(df, mapper_dict):
    # https://www.geeksforgeeks.org/combining-multiple-columns-in-pandas-groupby-with-dictionary/
    # Here we shall map data

    # Set the index of df as Column 'id'
    # df = df.set_index('id')
    df = df.groupby(mapper_dict, axis=1).sum()
    return df


def df_clean_amounts(df, amount_cols):
    df[amount_cols] = df[amount_cols].replace({'\$': '', ',': ''}, regex=True)
    df[amount_cols] = df[amount_cols].astype(float)
    return df


def df_clean_dates(df, date_cols):
    df[date_cols] = df[date_cols].apply(pd.to_datetime)

    df[date_cols] = df[date_cols].applymap(
        # NG: 2019-06-20 10:43am Kept for future reference
        # df[date_cols] = df[date_cols].applymap(lambda x: datetime.strftime(x, "%Y-%m-%d"))
        lambda x: datetime.fromtimestamp(x.timestamp(), tz=timezone.utc).isoformat()
    )
    return df


# https://www.geeksforgeeks.org/combining-multiple-columns-in-pandas-groupby-with-dictionary/
def transform_df_using_dict(df, mapper_dict):

    df = df_map_columns(df, mapper_dict)

    # Map the amount columns as float
    amount_cols = []
    for column in df.columns:
        if "Amount" in column or 'Quantity' in column:
            amount_cols.append(column)

    df_clean_amounts(df, amount_cols)

    # Serialize the date columns to a format of our choice
    # First we convert then to datetime format using pd.to_datetime function
    date_cols = []
    for column in df.columns:
        if "Date" in column:
            date_cols.append(column)

    df_clean_dates(df, date_cols)

    return df
