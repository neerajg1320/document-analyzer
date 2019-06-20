import pandas as pd
from datetime import datetime, timezone


def df_map_columns(df, mapper_dict):
    # https://www.geeksforgeeks.org/combining-multiple-columns-in-pandas-groupby-with-dictionary/
    # Here we shall map data

    # Set the index of df as Column 'id'
    # df = df.set_index('id')
    df = df.groupby(mapper_dict, axis=1).sum()
    return df


# TBD: Need to change these to Decimals
def df_clean_amount_columns(df, amount_cols):
    df[amount_cols] = df[amount_cols].replace({'\$': '', ',': ''}, regex=True)
    df[amount_cols] = df[amount_cols].astype(float)
    return df


def df_clean_date_columns(df, date_cols):
    df[date_cols] = df[date_cols].apply(pd.to_datetime)

    return df


def df_dates_str(date_cols, df):
    df[date_cols] = df[date_cols].applymap(
        lambda x: datetime.strftime(x, "%Y-%m-%d")
    )

    return df


def df_dates_iso_format(date_cols, df):
    df[date_cols] = df[date_cols].applymap(
        # NG: 2019-06-20 10:43am Kept for future reference
        # df[date_cols] = df[date_cols].applymap(lambda x: datetime.strftime(x, "%Y-%m-%d"))
        lambda x: datetime.fromtimestamp(x.timestamp(), tz=timezone.utc).isoformat()
    )

    return df


def df_get_amount_columns(df):
    amount_cols = []
    for column in df.columns:
        if "Amount" in column or 'Quantity' in column:
            amount_cols.append(column)
    return amount_cols


def df_get_date_columns(df):
    date_cols = []
    for column in df.columns:
        if "Date" in column:
            date_cols.append(column)
    return date_cols


def df_map_columns_by_groupbydict(df, mapper_dict):
    df = df_map_columns(df, mapper_dict)
    return df


def df_clean_amounts(df):
    # Map the amount columns as float
    amount_cols = df_get_amount_columns(df)

    df = df_clean_amount_columns(df, amount_cols)

    return df


def df_clean_dates(df):
    # Serialize the date columns to a format of our choice
    # First we convert then to datetime format using pd.to_datetime function
    date_cols = df_get_date_columns(df)

    df = df_clean_date_columns(df, date_cols)

    return df


# https://www.geeksforgeeks.org/combining-multiple-columns-in-pandas-groupby-with-dictionary/
def transform_df_using_dict(df, mapper_dict):

    # The following method will change the names to understood format
    df = df_map_columns_by_groupbydict(df, mapper_dict)

    # The following methods are dependent on the above method. So they have to follow
    df = df_clean_amounts(df)

    df = df_clean_dates(df)

    df = df_dates_iso_format(df_get_date_columns(df), df)

    return df




