import pandas as pd
from datetime import datetime


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
    df[date_cols] = df[date_cols].applymap(lambda x: datetime.strftime(x, "%Y-%m-%d"))
    return df


# https://www.geeksforgeeks.org/combining-multiple-columns-in-pandas-groupby-with-dictionary/
def transform_df_using_dict(df, mapper_dict):

    df = df_map_columns(df, mapper_dict)

    # Map the columns NetAmount, PrincipalAmount as float
    amount_cols = ['NetAmount', 'PrincipalAmount']
    df_clean_amounts(df, amount_cols)

    # Serialize the date columns to a format of our choice
    # First we convert then to datetime format using pd.to_datetime function
    date_cols = ['TradeDate', 'SettleDate']
    df_clean_dates(df, date_cols)

    return df
