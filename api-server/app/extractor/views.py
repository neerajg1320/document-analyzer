from rest_framework import viewsets, mixins, renderers
from rest_framework.response import Response
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import action
from rest_framework.views import APIView

from django.forms.models import model_to_dict

from core.models import Tag, Extractor, Document, File, Transaction, Schema, Operation, DatastoreInfo, DatastoreType, Pipeline

from extractor import serializers

from extractor.text_routines import create_highlighted_text, \
    create_transactions_from_text_tuples_str, create_transactions_dict_array_from_text

import pandas as pd

from extractor.pandas_routines import (df_clean_assign_type_for_floats,
                                       df_clean_assign_type_for_dates,
                                       df_clean_assign_type_for_integers,
                                       df_get_date_columns_by_type,
                                       df_get_columns_info_dataframe)

# Used for checking the dtypes
import numpy as np

import json
import hjson
from io import StringIO

from snowflake.sqlalchemy import URL
from sqlalchemy import create_engine


from extractor.pandas_routines import transform_df_using_dict, \
    df_columns_datetime_iso_format, df_columns_datetime_iso_date_format, \
    df_get_date_columns_by_name, df_dates_str, df_get_columns_info_dataframe

from extractor import excel_routines
from extractor import image_routines

# https://stackoverflow.com/questions/3056048/filename-and-line-number-of-python-script
from inspect import currentframe, getframeinfo

import pyap


# Until supported keep the mapping false for Excel documents
# The flag is manipulated in the FileViewSet::documentize functions
g_flag_process_data = True

g_decimal_places = 4

class BaseRecipeAttrViewSet(viewsets.GenericViewSet,
                            mixins.ListModelMixin,
                            mixins.CreateModelMixin):
    """ Base ViewSet for user owned recipe attributes """
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def get_queryset(self):
        """ Return objects for current user only """
        assigned_only = bool(
            int(self.request.query_params.get('assigned_only', 0))
        )
        queryset = self.queryset
        if assigned_only:
            queryset = queryset.filter(recipe__isnull=False)
        return queryset.filter(
            user=self.request.user
        ).order_by('-name').distinct()

    def perform_create(self, serializer):
        """ Create a new tag """
        serializer.save(user=self.request.user)


class TagViewSet(BaseRecipeAttrViewSet):
    """ Manage tags in the database """
    queryset = Tag.objects.all()
    serializer_class = serializers.TagSerializer


class ExtractorViewSet(viewsets.ModelViewSet):
    """ Manage extractors in database """
    queryset = Extractor.objects.all()

    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def get_queryset(self):
        """ Return objects for current user only """
        return self.queryset.filter(user=self.request.user)

    def perform_create(self, serializer):
        """ Create a new extractor """
        # TBD: Here we should perform is_staff check
        serializer.save(user=self.request.user)

    def perform_update(self, serializer):
        """ Create a new extractor """
        # TBD: Here we should perform is_staff check
        # print(serializer.validated_data)
        serializer.save(user=self.request.user)

    def get_serializer_class(self):
        """ Return appropriate serializer class """
        if self.action == 'retrieve' \
                or self.action == 'update' \
                or self.action == 'create':
            return serializers.ExtractorDetailSerializer

        # return self.serializer_class
        return serializers.ExtractorListSerializer


# Data mappers stored as string
# TBD: This part will be made configurable
#
trade_groupby_json = """{
    'trade_date': 'TradeDate',
    'setl_date': 'SettleDate',
    'trade_type': 'TradeType',
    'trade_qty': 'TradeQuantity',
    'principal': 'PrincipalAmount',
    'commission': 'Commission',
    'reg_fee': 'Fees',
    'net_amount': 'NetAmount',
    'option': 'Scrip',
    'symbol': 'Symbol',
}"""

creditcard_groupby_json = """{
    'date': 'Date',
    'description': 'Description',
    'amount': 'Amount',
    'type': 'Type',
}"""


def text_extract_dataframe_json(institute_name, document_type, input_text):
    # print("Creating transactions from document.text")
    # Lookup for the parser(extractor)
    #   based on institure name (e.g. HDFC) and document type (e.g. Savings Statement)
    extractors = Extractor.objects.filter(institute_name__iexact=institute_name,
                                          document_type__iexact=document_type)
    if not extractors:
        raise Exception("Extractor not found")
    transaction_regex_str = extractors[0].regex_parser
    # The following will send the data in json format
    transactions_array = create_transactions_dict_array_from_text(transaction_regex_str, input_text)
    df = pd.DataFrame(transactions_array)

    return df.to_json(orient='records')


# Store dataframe to snowflake
# We don't need to create the Table in snowflake.
# The first data transfer will create the table.
# TBD: The database properties to be made configurable.
#

# The following is stored in the datastores table
post_parameters_schema = [
    {"name":"user", "mandatory":"true", "type":"object" },
    {"name":"password", "mandatory":"true", "type":"object" },
    {"name":"host", "mandatory":"true", "type":"object" },
    {"name":"port", "mandatory":"true", "type":"int64" },
    {"name":"database", "mandatory":"true", "type":"object" },
    {"name":"table", "mandatory":"true", "type":"object" }
]

snowflake_properties_json = """{
    'user' : 'finball',
    'password' : 'Finball@2018',
    'account' : 'yw56161',
    'database' : 'Trades',
    'table' : 'USSTOCKS',
    'schema' : 'public',
    'warehouse' : 'compute_wh'
}"""


def get_snowflake_db_url(snowflake_properties_dict):
    db_url = URL(**snowflake_properties_dict)
    return db_url


def get_postgres_db_url(postgres_parameters):
    db_url = 'postgresql://' \
             + postgres_parameters['user'] \
             + ':' + postgres_parameters['password'] \
             + '@' + postgres_parameters['host'] \
             + ':' + postgres_parameters['port'] \
             + '/' + postgres_parameters['database']
    return db_url


from sqlalchemy import inspect


def get_tables_from_database(database_parameters):
    db_url = get_postgres_db_url(database_parameters)

    tables_list = []
    engine = create_engine(db_url)
    try:
        connection = engine.connect()

        inspector = inspect(engine)
        tables_list = inspector.get_table_names()

    except Exception as e:
        frameinfo = getframeinfo(currentframe())
        print("Exception[{}:{}]:".format(frameinfo.filename, frameinfo.lineno), e)
    finally:
        connection.close()
        engine.dispose()

    return tables_list


def get_columns_from_database(database_parameters, table_name):
    db_url = get_postgres_db_url(database_parameters)

    column_list = []
    engine = create_engine(db_url)
    try:
        connection = engine.connect()

        inspector = inspect(engine)
        # tables_list = inspector.get_table_names()
        column_list = inspector.get_columns(table_name)
    except Exception as e:
        frameinfo = getframeinfo(currentframe())
        print("Exception[{}:{}]:".format(frameinfo.filename, frameinfo.lineno), e)
    finally:
        connection.close()
        engine.dispose()

    return column_list


def save_to_snowflake(df, table_name, snowflake_parameters):
    db_url = get_snowflake_db_url(snowflake_parameters)

    save_to_sql(df, db_url, table_name)


def save_to_postgres(df, table_name, postgres_parameters):
    db_url = get_postgres_db_url(postgres_parameters)

    save_to_sql(df, db_url, table_name)


def save_to_sql(df, db_url, table_name):
    engine = create_engine(db_url)
    try:
        connection = engine.connect()

        # We are making the table_name lowercase to make it work smoothly with postgres
        df.to_sql(table_name.lower(), engine, index=False, if_exists='append')
    except Exception as e:
        frameinfo = getframeinfo(currentframe())
        print("Exception[{}:{}]:".format(frameinfo.filename, frameinfo.lineno), e)
    finally:
        connection.close()
        engine.dispose()


def load_from_sql(db_url, table_name):
    engine = create_engine(db_url)

    df = None
    try:
        connection = engine.connect()
        # results = connection.execute('select current_version()').fetchone()
        # print(results[0])

        df = pd.read_sql_query("SELECT * FROM {}".format(table_name), engine)
    except Exception as e:
        frameinfo = getframeinfo(currentframe())
        print("Exception[{}:{}]:".format(frameinfo.filename, frameinfo.lineno), e)
    finally:
        connection.close()
        engine.dispose()

    return df


def load_from_snowflake(table_name, snowflake_parameters):
    db_url = URL(**snowflake_parameters)

    return load_from_sql(db_url, table_name)


def load_from_postgres(table_name, postgres_parameters):
    db_url = get_postgres_db_url(postgres_parameters)

    return load_from_sql(db_url, table_name)


import re


def replace_chars(input_str, start_offset, end_offset, replace_char):
    replace_len = end_offset - start_offset
    new_str = input_str[:start_offset] + replace_char * replace_len + input_str[end_offset:]
    # print(new_str)
    return new_str

def replace_substr(input_str, start_offset, end_offset, replace_substr):
    replace_len = end_offset - start_offset
    new_str = input_str[:start_offset] + "<" + replace_substr + ">" + input_str[end_offset:]
    # print(new_str)
    return new_str

def replace_regex_with_chars(match_queue, regex_str_dict, input_str, token_name, replace_char):
    regex_str = regex_str_dict[token_name]
    pattern = re.compile(regex_str, re.MULTILINE)
    matches = pattern.finditer(input_str)

    new_str = input_str
    fields = sorted(pattern.groupindex.items(), key=lambda x: x[1])

    if len(fields) < 1:
        return new_str

    field_name = fields[0][0]

    field_name = token_name
    # print(fields)

    for match_num, match in enumerate(matches):
        match_num = match_num + 1

        start = match.start()
        end = match.end()
        new_str = replace_chars(new_str, start, end, replace_char)
        # new_str = replace_substr(new_str, start, end, field_name)
        match_queue.append((field_name, start, end, match.group()))

        if False:
            print("")
            print("Match {match_num} was found at {start}-{end}:"
                  .format(match_num = match_num,
                          start = start,
                          end = end))
            print("{match}".format(match = match.group()))

        for group_num in range(0, len(match.groups())):
            group_num = group_num + 1
            if False:
                print("Group {group_num} found at {start}-{end}: {group}"
                      .format(group_num = group_num,
                              start = match.start(group_num),
                              end = match.end(group_num),
                              group = match.group(group_num)))

    # print(new_str)
    return new_str


def convert_to_regex(text):
    # frameinfo = getframeinfo(currentframe())
    # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), text)

    optional_separator = r"[\s]{0,2}"
    mandatory_separator = r"[\s]{1,2}"

    currency = r"[\$]"
    date_regex_str_slash_separator = r"(?P<DateSlash>\d{2}\/\d{2}\/\d{2,4})"
    date_regex_str_hyphen_separator = r"(?P<DateHyphen>\d{2}-\d{2}-\d{2,4})"

    float_regex_str = r"(?P<Float>(?:[,\d]+)?(?:[.][\d]+))"
    amount_float_regex_str = (currency + optional_separator + float_regex_str).replace("Float", "AmountFloat")

    # \b is for the word boundary
    integer_regex_str = r"(?P<Integer>\b[,\d]+\b)"
    amount_integer_regex_str = (currency + optional_separator + integer_regex_str).replace("Integer", "AmountInteger")

    # - is not working for TDAmeritrade. But it is needed for some strings
    # r"(?P<String>[\w]+(?:<mandatory_separator>[\w]+)*)"

    # string_chars = "\w\&\/\:\*-"
    string_chars = "\S"

    # (?P<String0>[\w\&\/\:\*]+(?:[\s]{1,2}[\w\&\/\:\*]+){0,1})
    string_regex_str = r"(?P<String>[" + string_chars + "]+(?:" + mandatory_separator + "[" + string_chars + "]+){0,99999})"

    # set value to 1 to revert to the previous behaviour
    # However the string value can vary based on the number of words contained.
    # This should be non variable for the Strings at the beginning or at end of the regex
    string_max_len = 1

    regex_str_dict = {}

    regex_str_dict["DateSlash"] = date_regex_str_slash_separator
    regex_str_dict["DateHyphen"] = date_regex_str_hyphen_separator

    regex_str_dict["AmountFloat"] = amount_float_regex_str
    regex_str_dict["Float"] = float_regex_str

    regex_str_dict["AmountInteger"] = amount_integer_regex_str
    regex_str_dict["Integer"] = integer_regex_str

    regex_str_dict["String"] = string_regex_str

    replace_char = ' '
    new_str = text
    match_queue = []
    new_str = replace_regex_with_chars(match_queue, regex_str_dict, new_str, "DateSlash", replace_char)
    new_str = replace_regex_with_chars(match_queue, regex_str_dict, new_str, "DateHyphen", replace_char)

    new_str = replace_regex_with_chars(match_queue, regex_str_dict, new_str, "AmountFloat", replace_char)
    new_str = replace_regex_with_chars(match_queue, regex_str_dict, new_str, "Float", replace_char)

    new_str = replace_regex_with_chars(match_queue, regex_str_dict, new_str, "AmountInteger", replace_char)
    new_str = replace_regex_with_chars(match_queue, regex_str_dict, new_str, "Integer", replace_char)

    new_str = replace_regex_with_chars(match_queue, regex_str_dict, new_str, "String", replace_char)

    # frameinfo = getframeinfo(currentframe())
    # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), new_str)

    match_queue = sorted(match_queue, key=lambda x: x[1])

    # print('\n'.join(map(str, match_queue)))

    flag_regex_with_comment = True
    complete_regex_str = "(?#" if flag_regex_with_comment else ""
    token_type_count_dict = {}
    for i in range(0, len(match_queue)):
        token_type = match_queue[i][0]

        # print(str(i) + ": " + token_type)
        token_type_count = token_type_count_dict.get(token_type, None)
        if token_type_count is None:
            token_type_count = 0
            token_type_count_dict[token_type] = token_type_count

        regex_str_with_count = regex_str_dict[token_type].replace(token_type, token_type + str(token_type_count))
        # print(regex_str_with_count)
        complete_regex_str += "\n)" if flag_regex_with_comment else ""
        complete_regex_str +=  (mandatory_separator if i > 0 else  "") + regex_str_with_count
        complete_regex_str += "(?#" if flag_regex_with_comment else ""

        if token_type == "String":
            token_value = match_queue[i][3]
            max_len = max(len(re.split(mandatory_separator, token_value)), string_max_len)
            complete_regex_str = complete_regex_str.replace("99999", str(max_len - 1))

        token_type_count_dict[token_type] += 1

    complete_regex_str += "\n)" if flag_regex_with_comment else ""

    # frameinfo = getframeinfo(currentframe())
    # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), complete_regex_str)

    return complete_regex_str


class SchemaViewSet(viewsets.ModelViewSet):
    """ Manage documents in database """
    queryset = Schema.objects.all()

    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def get_queryset(self):
        """ Return objects for current user only """
        return self.queryset.filter(user=self.request.user)

    def perform_create(self, serializer):
        """ Create a new document """
        # TBD: Here we should perform is_staff check
        serializer.save(user=self.request.user)

    def perform_update(self, serializer):
        """ Create a new document """
        # TBD: Here we should perform is_staff check
        # print(serializer.validated_data)
        serializer.save(user=self.request.user)

    def get_serializer_class(self):
        """ Return appropriate serializer class """
        if self.action == 'retrieve' \
                or self.action == 'update' \
                or self.action == 'create':
            return serializers.SchemaDetailSerializer

        # return self.serializer_class
        return serializers.SchemaListSerializer


def apply_regex_on_text(complete_text, regex_str):
    match_queue = []
    regex_str_dict = {"Transaction": regex_str}
    new_str = replace_regex_with_chars(match_queue, regex_str_dict, complete_text, "Transaction", "-")

    # frameinfo = getframeinfo(currentframe())
    # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), '\n'.join(map(str, match_queue)))

    transactions_dict_array = create_transactions_dict_array_from_text(regex_str, complete_text)
    return new_str, transactions_dict_array


def destnation_schema_dataframe(schema_id):
    schema = Schema.objects.get(pk=schema_id)
    # frameinfo = getframeinfo(currentframe())
    # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), json.loads(schema.fields_json))

    destination_table = json.loads(schema.fields_json)
    return pd.DataFrame(destination_table)


def assign_new_datatypes(schema_df, agg_df):
    # Then we assign the new column types
    # https://stackoverflow.com/questions/21197774/assign-pandas-dataframe-column-dtypes
    # Create dictionary from two columns
    # https://stackoverflow.com/questions/17426292/what-is-the-most-efficient-way-to-create-a-dictionary-of-two-pandas-dataframe-co
    new_dtypes_dict = pd.Series(schema_df.type.values, index=schema_df.name).to_dict()

    numeric_columns = []
    numeric_columns += schema_df.loc[schema_df['type'] == 'float64']['name'].tolist()
    numeric_columns += schema_df.loc[schema_df['type'] == 'int64']['name'].tolist()

    for col in numeric_columns:
        try:
            if col in agg_df.columns:
                if agg_df[col].dtype == 'object':
                    agg_df[col] = agg_df[col].str.replace(',', '')
        except KeyError as e:
            frameinfo = getframeinfo(currentframe())
            print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno),
                  "KeyError:" + str(e))

    # We change only the fields which are present in the dataframe
    available_new_dtypes_dict = {}
    for key, value in new_dtypes_dict.items():
        if key in agg_df.columns:
            available_new_dtypes_dict[key] = value
            if value == "date":
                available_new_dtypes_dict[key] = "datetime64[ns]"

    # frameinfo = getframeinfo(currentframe())
    # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), json.dumps(available_new_dtypes_dict, indent=4))

    try:
        agg_df = agg_df.astype(dtype=available_new_dtypes_dict).round(g_decimal_places)
    except ValueError as e:
        frameinfo = getframeinfo(currentframe())
        print("Exception[{}:{}]:".format(frameinfo.filename, frameinfo.lineno), e)
    except KeyError as e:
        frameinfo = getframeinfo(currentframe())
        print("Exception[{}:{}]:".format(frameinfo.filename, frameinfo.lineno), e)

    # frameinfo = getframeinfo(currentframe())
    # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), agg_df.dtypes)

    return agg_df


def map_existing_fields(schema_df, mapper, df):
    column_mapper_df = pd.DataFrame(mapper)

    mapped_df = pd.DataFrame()

    # For aggregation where necessary, find out how many src columns are mapping to a destination column.
    dst_column_dict = {}
    for index, row in column_mapper_df.iterrows():
        if row['mapping'] != "IGNORE":
            dst_column = row['dst']
            src_column = row['src']

            if dst_column != "None":
                if dst_column_dict.get(dst_column, None) is None:
                    dst_column_dict[dst_column] = []

                dst_column_dict[dst_column].append(src_column)

            if row['mapping'] == "SPLIT_SEP":
                parameters = json.loads(row['parameters'])

                frameinfo = getframeinfo(currentframe())
                print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), json.dumps(parameters))

                separator = ' '
                if 'separator' in parameters:
                    separator = parameters['separator']
                split_df = df[src_column].str.split(separator, expand=True)

                columns = split_df.columns
                if 'columns' in parameters:
                    columns = parameters["columns"]

                mapped_df[columns] = split_df

            elif row['mapping'] == "SPLIT_REGEX_STATIC":
                parameters = json.loads(row['parameters'])

                regex = ''
                if 'regex' in parameters:
                    regex = parameters['regex']

                split_df = df[src_column].str.extract(regex, expand=True)

                columns = split_df.columns
                if 'columns' in parameters:
                    columns = parameters["columns"]

                mapped_df[columns] = split_df

    # frameinfo = getframeinfo(currentframe())
    # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), mapped_df)

    # Aggregate multiple src_columns mapped to same dst_column
    #

    for dst_col, src_col_list in dst_column_dict.items():
        try:
            schema_row = schema_df.loc[schema_df['name'] == dst_col].iloc[0]
        except Exception as e:
            frameinfo = getframeinfo(currentframe())
            print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), dst_col, e)

        # frameinfo = getframeinfo(currentframe())
        # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), dst_col, src_col_list, "\n", schema_row)

        if len(src_col_list) > 1:
            # https://stackoverflow.com/questions/17071871/select-rows-from-a-dataframe-based-on-values-in-a-column-in-pandas
            aggregate_fn = schema_row['aggregation']
            mapped_df[dst_col] = df[src_col_list].agg(aggregate_fn, axis="columns")
        else:

            mapped_df[dst_col] = df[src_col_list[0]]

    # frameinfo = getframeinfo(currentframe())
    # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), mapped_df)

    return mapped_df


def create_new_fields(new_fields, src_df, mapped_df):
    if new_fields is not None:
        for field in new_fields:

            if not field['active']:
                continue

            if field['type'] == "Generate-Regex":

                # frameinfo = getframeinfo(currentframe())
                # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), type(field), field)
                # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), type(field['value']), field['value'])

                if 'src' in field:
                    src_column = field['src']
                elif 'temp_name' in field:
                    src_column = field['temp_name']
                    src_df = mapped_df
                elif 'dst' in field:
                    src_column = field['dst']
                    src_df = mapped_df

                parameters = json.loads(field['value'])

                regex = ''
                if 'regex' in parameters:
                    regex = parameters['regex']

                split_df = src_df[src_column].str.extract(regex, expand=True)

                # Rename the column names if specified
                columns = split_df.columns
                if 'columns' in parameters:
                    columns = parameters["columns"]
                    split_df.columns = columns

                # Create the columns which are not present in the mapped dataframe
                column_mapper = {}
                for column in columns:
                    if column not in mapped_df:
                        if '_' in column:
                            col_info = column.split('_')
                            col_name = col_info[0]
                            col_type = col_info[1]
                            if len(col_info) > 2:
                                col_default = col_info[2]
                            else:
                                col_default = None

                            # frameinfo = getframeinfo(currentframe())
                            # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), col_name, col_type, col_default)

                            column_mapper[column] = col_name
                            if col_type == "float":
                                if col_default is None:
                                    col_default = "0.0"
                                col_default = col_default.replace('d', '.').replace('n', '-')
                                mapped_df[column] = float(col_default)
                            elif col_type == "int":
                                if col_default is None:
                                    col_default = "0"
                                col_default = col_default.replace('d', '.').replace('n', '-')
                                mapped_df[column] = int(col_default)
                            elif col_type == "str":
                                if col_default is None:
                                    col_default = ""
                                mapped_df[column] = str(col_default)
                            else:
                                mapped_df[column] = np.nan
                        else:
                            mapped_df[column] = np.nan

                # Update only the non NaN values from the newly generated dataframe
                mapped_df.update(split_df)

                # Now rename the columns
                mapped_df = mapped_df.rename(columns=column_mapper)

            else:
                field_name = ""
                if field['type'] == "Generate-Temp":
                    field_name = field['temp_name']
                elif field['type'] == "Generate-Final":
                    field_name = field['dst']

                if field_name is not None and field_name != "":
                    code_str = "df['%s'] = %s" % (field_name, field['value'])
                    # Don't delete the following line. df is used in following line exec(code_str)
                    df = mapped_df
                    # frameinfo = getframeinfo(currentframe())
                    # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), code_str)
                    exec(code_str)

                mapped_df = mapped_df.round(g_decimal_places)

    return mapped_df


def apply_mapper_on_dataframe(mapper_parameters, src_df):
    destination_table = mapper_parameters["destination_table"]
    mapper = json.loads(mapper_parameters["existing_fields"])
    new_fields = None
    if "new_fields" in mapper_parameters:
        new_fields = json.loads(mapper_parameters["new_fields"])

    schema_df = destnation_schema_dataframe(destination_table)

    mapped_df = map_existing_fields(schema_df, mapper, src_df)
    mapped_df = assign_new_datatypes(schema_df, mapped_df)

    if new_fields is not None:
        mapped_df = create_new_fields(new_fields, src_df, mapped_df)

    for entry in new_fields:
        if entry["type"] == "Temp":
            mapped_df = mapped_df.drop(entry["temp_name"], axis=1)

    remaining_columns = list(filter(lambda column: column not in mapped_df.columns, schema_df['name']))
    for column in remaining_columns:
        mapped_df[column] = ''

    return mapped_df


def load_frame_from_datastore_table(table_name, datastore_type, datastore_credentials):
    df = None
    if str(datastore_type).lower() == 'snowflake':
        df = load_from_snowflake(table_name, datastore_credentials)
    elif str(datastore_type).lower() == 'postgres':
        df = load_from_postgres(table_name, datastore_credentials)

    return df


def load_frame_into_datastore_table(datastore_type, datastore_credentials, table_name, dataframe):
    if str(datastore_type).lower() == 'snowflake':
        #  This is the mapping according to the hardcoded regex extractor
        #
        # flag_process_data = g_flag_process_data
        # if flag_process_data:
        #     # Need to be lookup based
        #     groupby_dict = self.get_groupby_dict(document)
        #     df = transform_df_using_dict(df, groupby_dict)
        save_to_snowflake(dataframe, table_name, datastore_credentials)
        # df = load_from_snowflake(datastore_parameters)
    elif str(datastore_type).lower() == 'postgres':
        save_to_postgres(dataframe, table_name, datastore_credentials)


class DocumentViewSet(viewsets.ModelViewSet):
    """ Manage documents in database """
    queryset = Document.objects.all()

    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def get_queryset(self):
        """ Return objects for current user only """
        return self.queryset.filter(user=self.request.user)

    def perform_create(self, serializer):
        """ Create a new document """
        # TBD: Here we should perform is_staff check
        serializer.save(user=self.request.user)

    def perform_update(self, serializer):
        """ Create a new document """
        # TBD: Here we should perform is_staff check
        # print(serializer.validated_data)
        serializer.save(user=self.request.user)

    def get_serializer_class(self):
        """ Return appropriate serializer class """
        if self.action == 'retrieve' \
                or self.action == 'update' \
                or self.action == 'create':
            return serializers.DocumentDetailSerializer

        # return self.serializer_class
        return serializers.DocumentListSerializer

    @action(detail=True, renderer_classes=[renderers.StaticHTMLRenderer, renderers.JSONRenderer])
    def highlight(self, request, *args, **kwargs):
        document = self.get_object()
        if document.highlighted is None or document.highlighted == "":
            document.highlighted = create_highlighted_text(document.text, title=document.title)
            super(Document, document).save()
        return Response(document.highlighted)

    @action(detail=True, methods=['post'], renderer_classes=[renderers.StaticHTMLRenderer, renderers.JSONRenderer])
    def regex_create(self, request, *args, **kwargs):
        document = self.get_object()

        # Right now we can assume one document one table. But this is not necessarily true
        selected_text = request.data.get("selected_text", None)
        complete_text = request.data.get("complete_text", None)

        # print(complete_text)

        regex_str = ""
        if selected_text is not None:
            regex_str = convert_to_regex(selected_text)

        match_queue = []
        regex_str_dict = {"Transaction": regex_str}
        new_str = replace_regex_with_chars(match_queue, regex_str_dict, complete_text, "Transaction", "-")
        # print(new_str)

        # frameinfo = getframeinfo(currentframe())
        # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), '\n'.join(map(str, match_queue)))
        #
        # transactions_dict_array = create_transactions_dict_array_from_text(regex_str, complete_text)
        # document.transactions_json = json.dumps(transactions_dict_array)
        # super(Document, document).save()

        response_dict = {
            "regex": regex_str,
            "new_str": new_str,
            # "transactions": transactions_dict_array,
        }

        # Response should be a regex
        return Response(response_dict)

    @action(detail=True, methods=['post'], renderer_classes=[renderers.StaticHTMLRenderer, renderers.JSONRenderer])
    def regex_apply(self, request, *args, **kwargs):
        document = self.get_object()

        # Right now we can assume one document one table. But this is not necessarily true
        regex_str = request.data.get("regex_text", None)
        complete_text = request.data.get("complete_text", None)

        # print(regex_str)
        # print(complete_text)

        new_str, transactions_dict_array = apply_regex_on_text(complete_text, regex_str)

        response_dict = {
            "new_str": new_str,
            "dataframe": str(pd.DataFrame(transactions_dict_array)),
            "transactions": transactions_dict_array,
        }

        # We update the transactions dataframe stored as json
        document.transactions_json = json.dumps(transactions_dict_array)
        super(Document, document).save()

        # Response should be a regex
        return Response(response_dict)

    @action(detail=True, renderer_classes=[renderers.StaticHTMLRenderer])
    def transactions(self, request, *args, **kwargs):
        document = self.get_object()
        # unconditionally enabled temporarily
        if document.transactions_json is None or document.transactions_json == "":
            # Lookup for the parser(extractor)
            #   based on institure name (e.g. HDFC) and document type (e.g. Savings Statement)
            extractors = Extractor.objects.filter(institute_name__iexact=document.institute_name,
                                                  document_type__iexact=document.document_type)
            if not extractors:
                raise Exception("Extractor not found")

            transaction_regex_str = extractors[0].regex_parser

            # The following will send the table header first and then table rows as values
            document.transactions_json = create_transactions_from_text_tuples_str(transaction_regex_str, document.text)

            super(Document, document).save()

        highlighted_text = create_highlighted_text(document.transactions_json, title="Transactions")
        return Response(highlighted_text)

    def get_or_create_transactions_array(self):
        document = self.get_object()
        # unconditionally enabled temporarily
        if document.transactions_json is None or document.transactions_json == "":
            # print("Creating transactions from document.text")
            # Lookup for the parser(extractor)
            #   based on institure name (e.g. HDFC) and document type (e.g. Savings Statement)
            extractors = Extractor.objects.filter(institute_name__iexact=document.institute_name,
                                                  document_type__iexact=document.document_type)
            if not extractors:
                raise Exception("Extractor not found")

            transaction_regex_str = extractors[0].regex_parser

            # The following will send the data in json format
            transactions_array = create_transactions_dict_array_from_text(transaction_regex_str, document.text)
            document.transactions_json = json.dumps(transactions_array)

            super(Document, document).save()
        else:
            transactions_array = json.loads(document.transactions_json)

        return document, transactions_array

    @action(detail=True, renderer_classes=[renderers.JSONRenderer])
    def transactions_json(self, request, *args, **kwargs):
        document, transactions_array = self.get_or_create_transactions_array()

        return Response(transactions_array)

    def get_or_create_transactions_dataframe(self):
        document = self.get_object()
        try:
            df = pd.read_json(document.transactions_json)
        except ValueError as e:
            df = pd.DataFrame()
            frameinfo = getframeinfo(currentframe())
            print("Exception[{}:{}]:".format(frameinfo.filename, frameinfo.lineno), e)

        return document, df

    def get_groupby_dict(self, document):
        if document.document_type == "ContractNote":
            groupby_dict_json = trade_groupby_json
        elif document.document_type == "CreditCardStatement":
            groupby_dict_json = creditcard_groupby_json

        groupby_dict = hjson.loads(groupby_dict_json)

        return groupby_dict

    def create_transactions(self, document, transactions_array):
        for transaction in transactions_array:
            # print(type(transaction), transaction)
            Transaction.objects.create(user=self.request.user, doc=document, **transaction)

    @action(detail=True, renderer_classes=[renderers.JSONRenderer])
    def mapped_transactions_json(self, request, *args, **kwargs):
        document, df = self.get_or_create_transactions_dataframe()

        # print("Before Processing")
        # print(df['date'])

        flag_process_data = g_flag_process_data
        flag_create_transactions = False

        if flag_process_data:
            # Need to be lookup based
            groupby_dict = self.get_groupby_dict(document)
            df = transform_df_using_dict(df, groupby_dict)
            # df = df_columns_dates_iso_format(df)
            df = df_dates_str(df)

        # print("Before Sending")
        # print(df.dtypes)

        transactions_array = json.loads(df.to_json(orient='records'))

        if flag_create_transactions:
            self.create_transactions(document, transactions_array)

        return Response(transactions_array)

    @action(detail=True, renderer_classes=[renderers.JSONRenderer])
    def mapped_transactions_csv(self, request, *args, **kwargs):
        document, df = self.get_or_create_transactions_dataframe()

        flag_process_data = g_flag_process_data
        if flag_process_data:
            # Need to be lookup based
            groupby_dict = self.get_groupby_dict(document)
            df = transform_df_using_dict(df, groupby_dict)

        buf = StringIO()
        df.to_csv(buf, index=False)

        return Response(buf.getvalue())

    # Should use the reverse function
    @action(detail=True, renderer_classes=[renderers.JSONRenderer])
    def transactions_dataframe(self, request, *args, **kwargs):
        document, df = self.get_or_create_transactions_dataframe()
        transactions_pandas_str = str(df)

        return Response(transactions_pandas_str)

    # Should use the reverse function
    @action(detail=True, renderer_classes=[renderers.StaticHTMLRenderer])
    def transactions_html(self, request, *args, **kwargs):
        document, df = self.get_or_create_transactions_dataframe()
        transactions_pandas_str = df.to_html()

        return Response(transactions_pandas_str)

    @action(detail=True, renderer_classes=[renderers.JSONRenderer])
    def transactions_get_mapper(self, request, *args, **kwargs):
        document, df = self.get_or_create_transactions_dataframe()

        frameinfo = getframeinfo(currentframe())
        print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), document, df)

        columns_df = df_get_columns_info_dataframe(df)
        columns_array = json.loads(columns_df.to_json(orient='records'))

        return Response(columns_array)

    @action(detail=True, renderer_classes=[renderers.JSONRenderer])
    def transactions_post_mapper(self, request, *args, **kwargs):
        document, df = self.get_or_create_transactions_dataframe()

        destination_table_name = request.data.get("destination_table", None)
        existing_fields_mapper = json.loads(request.data.get("existing_fields", None))
        new_fields = json.loads(request.data.get("new_fields", None))

        df = apply_mapper_on_dataframe(destination_table_name, existing_fields_mapper, new_fields, df)

        try:
            response_dict = {
                "mapped_df": str(df),
                "mapped_df_json": df.to_json(orient='records'),
            }
        except Exception as e:
            response_dict = {}

        # Response should be a regex
        return Response(response_dict)

    # Should use the reverse function
    @action(detail=True, renderer_classes=[renderers.StaticHTMLRenderer])
    def transactions_save(self, request, *args, **kwargs):
        document, df = self.get_or_create_transactions_dataframe()

        datastore_parameters = None
        # print(json.dumps(request.data, indent=4));

        datastore_type = request.data.get("store_type", None)
        if datastore_type is not None:
            datastore_parameters_json = request.data.get("parameter_values", None)
            if datastore_parameters_json is not None:
                datastore_parameters = json.loads(datastore_parameters_json)

        mapped_df = None
        mapped_df_json = request.data.get("dataframe_json", None)
        if mapped_df_json is not None:
            # The pd.read_json() is compatible with JSON.stringify()
            mapped_df = pd.read_json(mapped_df_json)
            # TBD: We need to assign types from the Destination Header Table
            # In cache this problem won't be there as we are already assigning types


        transactions_array = []

        if datastore_parameters is not None and mapped_df is not None:
            load_frame_into_datastore_table(datastore_type, datastore_parameters, "TBD", mapped_df)

            transactions_array = json.loads(mapped_df.to_json(orient='records'))

        return Response(transactions_array)


from rest_framework.response import Response
from django.conf import settings
import os
from extractor.pdf_routines import read_pdf, is_encrypted_pdf, decrypt_pdf, \
    pdftotext_read_pdf, pdftotext_read_pdf_using_subprocess


def get_file_path(file):
    file_path = os.path.join(settings.MEDIA_ROOT, str(file.file))
    return file_path


# https://stackoverflow.com/questions/52389956/uploading-multiple-files-using-django-rest-framework-without-using-forms



def create_files_from_http_request(request):
    files_list = request.data.getlist('file')
    file_id_array = []
    for file in files_list:
        fobj = File.objects.create(user=request.user,
                                   file=file,
                                   title=request.data.get('title'),
                                   institute_name=request.data.get('institute_name'),
                                   document_type=request.data.get('document_type'),
                                   password=request.data.get('password'),
                                   remark=request.data.get('remark'),
                                   )
        # frameinfo = getframeinfo(currentframe())
        # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), model_to_dict(fobj))
        file_id_array.append(fobj.id)

    return file_id_array


class FolderUpload(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request, *args, **kwargs):
        files =create_files_from_http_request(request)
        return Response({'files': files})


class FileViewSet(viewsets.ModelViewSet):
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    queryset = File.objects.all()
    serializer_class = serializers.FileListSerializer

    def get_queryset(self):
        """ Return objects for current user only """
        return self.queryset.filter(user=self.request.user)

    def perform_create(self, serializer):
        """ Create a new document """
        # TBD: Here we should perform is_staff check
        obj = serializer.save(user=self.request.user)
        for file in self.request.data.getlist('file'):
            frameinfo = getframeinfo(currentframe())
            print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), file)
            mf = File.objects.create(user=self.request.user, file=file)
            # obj.files.add(mf)

    def perform_update(self, serializer):
        """ Create a new document """
        # TBD: Here we should perform is_staff check
        # print(serializer.validated_data)
        serializer.save(user=self.request.user)

    def get_serializer_class(self):
        """ Return appropriate serializer class """
        if self.action == 'retrieve' \
                or self.action == 'update' \
                or self.action == 'create':
            return serializers.FileDetailSerializer

        # return self.serializer_class
        return serializers.FileListSerializer

    @action(detail=True, renderer_classes=[renderers.StaticHTMLRenderer, renderers.JSONRenderer])
    def textify(self, request, *args, **kwargs):
        file = self.get_object()

        if file.text is None or file.text == "" or True:
            file_path = self.get_file_path(file)
            file.text = pdftotext_read_pdf_using_subprocess(file_path, file.password)
            super(File, file).save()

        return Response(file.text)

    @action(detail=True, renderer_classes=[renderers.JSONRenderer])
    def documentize(self, request, *args, **kwargs):
        file = self.get_object()
        file_path = get_file_path(file)

        global g_flag_process_data

        if file.text is None or file.text == "" or True:
            file_name, file_extn = os.path.splitext(file_path)

            file_transactions_json = "Format {} not supported".format(file_extn)
            if file_extn.lower() == '.pdf':
                # We first read the pdf, the password is used in case pdf is encrypted
                file.text = pdftotext_read_pdf_using_subprocess(file_path, file.password)
                # The we extract the transactions from the text
                # try:
                #     file_transactions_json = text_extract_dataframe_json(file.institute_name,
                #                                                      file.document_type,
                #                                                      file.text)
                # except Exception as e:
                #     pass  # Ignore for now

                g_flag_process_data = True
            elif excel_routines.is_file_extn_excel(file_extn):
                file.text = excel_routines.excel_to_text(file_path)

                # file_transactions_json = excel_routines.excel_to_json(file_path)

                g_flag_process_data = False
            elif image_routines.is_file_extn_image(file_extn):
                file.text = image_routines.image_to_text(file_path)
                g_flag_process_data = True
            else :
                file.text = "Format {} not supported".format(file_extn)

            super(File, file).save()

        document = Document.objects.create(user=file.user,
                                           title=file.title,
                                           institute_name=file.institute_name,
                                           document_type=file.document_type,
                                           text=file.text,
                                           transactions_json=file_transactions_json)
        # print(document)

        document_serialized = serializers.DocumentDetailSerializer(document)
        return Response(document_serialized.data)


class TransactionViewSet(viewsets.ModelViewSet):
    """ Manage documents in database """
    queryset = Transaction.objects.all()

    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    serializer_class = serializers.TransactionListSerializer

    def get_queryset(self):
        """ Return objects for current user only """
        return self.queryset.filter(user=self.request.user)

    def perform_create(self, serializer):
        """ Create a new document """
        # TBD: Here we should perform is_staff check
        serializer.save(user=self.request.user)

    def perform_update(self, serializer):
        """ Create a new document """
        # TBD: Here we should perform is_staff check
        # print(serializer.validated_data)
        serializer.save(user=self.request.user)


class OperationViewSet(viewsets.ModelViewSet):
    """ Manage documents in database """
    queryset = Operation.objects.all()

    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)
    filterset_fields = ['type']

    def get_queryset(self):
        """ Return objects for current user only """
        return self.queryset.filter(user=self.request.user)

    def perform_create(self, serializer):
        """ Create a new document """
        # TBD: Here we should perform is_staff check
        serializer.save(user=self.request.user)

    def perform_update(self, serializer):
        """ Create a new document """
        # TBD: Here we should perform is_staff check
        # print(serializer.validated_data)
        serializer.save(user=self.request.user)

    def get_serializer_class(self):
        """ Return appropriate serializer class """
        if self.action == 'retrieve' \
                or self.action == 'update' \
                or self.action == 'create':
            return serializers.OperationDetailSerializer

        # return self.serializer_class
        return serializers.OperationListSerializer

    @action(detail=False, methods=['post'], renderer_classes=[renderers.JSONRenderer])
    def apply(self, request, *args, **kwargs):
        if not "operation_params" in request.data:
            return Response({"error": "Missing field 'operation_params'"})
        if not "dataframe_json" in request.data:
            return Response({"error": "Missing field 'dataframe_json'"})

        # frameinfo = getframeinfo(currentframe())
        # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), request.data)

        operation = json.loads(request.data.get("operation_params"))
        df = pd.read_json(request.data.get("dataframe_json"))

        operations_parameters = json.loads(operation["parameters"])

        response_dict = {}

        if operation["type"] == "Load":
            apply_loader_on_dataframe(operations_parameters, df)
            response_dict = {"msg": "DataFrame Loaded into Datastore"}

        elif operation["type"] == "Transform":
            df = apply_mapper_on_dataframe(operations_parameters, df)

            # Serialize the dates before sending
            date_cols = df_get_date_columns_by_type(df)
            df = df_columns_datetime_iso_date_format(df, date_cols)

            try:
                response_dict = {
                    "mapped_df": str(df),
                    "mapped_df_json": df.to_json(orient='records'),
                }
            except Exception as e:
                response_dict = {}
        elif operation["type"] == "Extract":

            # The difference between table_dict and df:
            # The table_dict has original extracted strings
            # The df has the values in which the types have been inferred
            # This results in the display of dates, numbers different for the two
            new_str, table_dict, df, schema_df = apply_extractor_on_dataframe(operations_parameters, df)

            # date_cols = df_get_date_columns_by_type(df)
            # df = df_columns_datetime_iso_date_format(df, date_cols)
            # table_dict = json.loads(df.to_json(orient='records'))

            pd.options.display.max_colwidth = 100
            response_dict = {
                "new_str": new_str,
                # "dataframe": str(schema_df),
                "dataframe": str(df[['scrip_commission_fee']]),
                "transactions": table_dict,
                "schema": json.loads(schema_df.to_json(orient='records'))
            }

        return Response(response_dict)

    @action(detail=True, renderer_classes=[renderers.StaticHTMLRenderer, renderers.JSONRenderer])
    def get_loader_tables(self, request, *args, **kwargs):
        operation = self.get_object()
        loader_parameters = json.loads(operation.parameters)

        response = {}
        if operation.type not in ["Extract", "Load"]:
            response["error"] = "operation type %s not supported" % operation.type
            return Response(response)

        # datastore_type = loader_parameters['type']
        #
        # datastore_parameters = json.loads(loader_parameters['properties'])

        # print(get_tables_from_database(datastore_parameters))
        #
        # columns = get_columns_from_database(datastore_parameters, 'trades')
        # column_names = list(map(lambda x: x["name"], columns))
        # print(column_names)

        # print("%s: %s" %(datastore_type, json.dumps(datastore_parameters, indent=4)))

        serializer = self.get_serializer(operation)
        return Response(serializer.data)


class DatastoreTypeViewSet(viewsets.ModelViewSet):
    """ Manage documents in database """
    queryset = DatastoreType.objects.all()

    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def get_queryset(self):
        """ Return objects for current user only """
        return self.queryset.filter(user=self.request.user)

    def perform_create(self, serializer):
        """ Create a new document """
        # TBD: Here we should perform is_staff check
        serializer.save(user=self.request.user)

    def perform_update(self, serializer):
        """ Create a new document """
        # TBD: Here we should perform is_staff check
        # print(serializer.validated_data)
        serializer.save(user=self.request.user)

    def get_serializer_class(self):
        """ Return appropriate serializer class """
        if self.action == 'retrieve' \
                or self.action == 'update' \
                or self.action == 'create':
            return serializers.DatastoreTypeDetailSerializer

        # return self.serializer_class
        return serializers.DatastoreTypeListSerializer


class DatastoreInfoViewSet(viewsets.ModelViewSet):
    """ Manage documents in database """
    queryset = DatastoreInfo.objects.all()

    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def get_queryset(self):
        """ Return objects for current user only """
        return self.queryset.filter(user=self.request.user)

    def perform_create(self, serializer):
        """ Create a new document """
        # TBD: Here we should perform is_staff check
        serializer.save(user=self.request.user)

    def perform_update(self, serializer):
        """ Create a new document """
        # TBD: Here we should perform is_staff check
        # print(serializer.validated_data)
        serializer.save(user=self.request.user)

    def get_serializer_class(self):
        """ Return appropriate serializer class """
        if self.action == 'retrieve' \
                or self.action == 'update' \
                or self.action == 'create':
            return serializers.DatastoreInfoDetailSerializer

        # return self.serializer_class
        return serializers.DatastoreInfoListSerializer


def file_to_text(file_path, password=None):
    file_name, file_extn = os.path.splitext(file_path)

    if file_extn.lower() == '.pdf':
        # We first read the pdf, the password is used in case pdf is encrypted
        text = pdftotext_read_pdf_using_subprocess(file_path, password)
    elif excel_routines.is_file_extn_excel(file_extn):
        text = excel_routines.excel_to_text(file_path)
    elif image_routines.is_file_extn_image(file_extn):
        text = image_routines.image_to_text(file_path)
    else:
        text = "Format {} not supported".format(file_extn)

    return text


def apply_extractor_on_dataframe(parameters, df):
    # frameinfo = getframeinfo(currentframe())
    # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), parameters)

    new_str = None
    table_dict = None
    new_df = None
    extractor_type = parameters["type"]

    if extractor_type == "regex":
        text = df['text'].iloc[0]
        parameters = parameters["parameters"]
        regex_str = parameters["regex"]

        new_str, table_dict = apply_regex_on_text(text, regex_str)
        new_df = pd.DataFrame(table_dict)

        # The following methods are dependent on the above method. So they have to follow
        new_df = df_clean_assign_type_for_dates(new_df)
        new_df = df_clean_assign_type_for_floats(new_df)
        new_df = df_clean_assign_type_for_integers(new_df)

    elif extractor_type == "excel":
        text = df['text'].iloc[0]
        input_csv = StringIO(text)

        new_df = pd.read_csv(input_csv)
        table_dict = json.loads(new_df.to_json(orient='records'))

    elif extractor_type == "database":
        # Get the table from database
        parameters = json.loads(parameters["parameters"])
        datastore_type, table_name, datastore_credentials = read_datastore_parameters(parameters)

        new_df = load_frame_from_datastore_table(table_name, datastore_type, datastore_credentials)
        if new_df is None:
            new_df = pd.DataFrame()
        table_dict = json.loads(new_df.to_json(orient='records'))

    else:
        raise RuntimeError("Extractor type '%s' not supported" % extractor_type)

    schema_df = df_get_columns_info_dataframe(new_df)

    # frameinfo = getframeinfo(currentframe())
    # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), schema_df)

    return new_str, table_dict, new_df, schema_df


def read_datastore_parameters(parameters):
    # frameinfo = getframeinfo(currentframe())
    # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), parameters)

    table_name = parameters["table"]
    datastore_id = parameters["datastore_id"]

    datastore = DatastoreInfo.objects.get(pk=datastore_id)
    if datastore is None:
        raise RuntimeError("Datastore not found for datastore id '%s'" % str(datastore_id))

    credentials = json.loads(datastore.parameters)

    return datastore.type.title, table_name, credentials


def apply_loader_on_dataframe(loader_parameters, df):
    datastore_type, table_name, datastore_credentials = read_datastore_parameters(loader_parameters)
    load_frame_into_datastore_table(datastore_type, datastore_credentials, table_name, df)

    return df


def apply_pipeline_on_text(file_text, pipeline):
    current_df = pd.DataFrame()

    # We need the pipeline operations array in order
    # TBD
    for operation in pipeline.operations.all():
        # frameinfo = getframeinfo(currentframe())
        # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), "%s" % (operation.type))
        parameters = json.loads(operation.parameters)

        if operation.type == "Extract":
            df_dict = [{"text": file_text}]
            current_df = pd.DataFrame(df_dict)
            new_str, table_dict, current_df, schema_df = apply_extractor_on_dataframe(parameters, current_df)
        elif operation.type == "Transform":
            current_df = apply_mapper_on_dataframe(parameters, current_df)
        elif operation.type == "Load":
            current_df = apply_loader_on_dataframe(parameters, current_df)
        else:
            raise RuntimeError("Operation %s not found" % operation.type)

        schema_df = df_get_columns_info_dataframe(current_df)

        # frameinfo = getframeinfo(currentframe())
        # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), current_df)

    return current_df, schema_df


class PipelineViewSet(viewsets.ModelViewSet):
    """ Manage recipes in database """
    queryset = Pipeline.objects.all()
    serializer_class = serializers.PipelineSerializer
    authentication_classes = (TokenAuthentication,)
    permission_classes = (IsAuthenticated,)

    def _params_to_int(self, qs):
        """ Convert a list of string IDs to a list of integers """
        return [int(str_id) for str_id in qs.split(',')]

    def get_queryset(self):
        """ Return objects for current user only """
        operations = self.request.query_params.get('operations')
        queryset = self.queryset

        if operations:
            operations_ids = self._params_to_int(operations)
            queryset = queryset.filter(operations__id__in=operations_ids)

        return queryset.filter(user=self.request.user)

    def get_serializer_class(self):
        """ Return appropriate serializer class """
        if self.action == 'retrieve':
            return serializers.PipelineDetailSerializer
        return self.serializer_class

    def perform_create(self, serializer):
        """ Create a new recipe """
        serializer.save(user=self.request.user)

    @action(detail=False, methods=['post'], renderer_classes=[renderers.JSONRenderer])
    def apply(self, request, *args, **kwargs):
        response = {}

        pipeline_id = request.data.get("pipeline_id", None)
        if pipeline_id is None:
            response["error"] = "Pipeline id %s not found" % pipeline_id

        files = request.data.getlist("files[]", None)

        if files and pipeline_id:
            combined_df = pd.DataFrame()
            combined_schema_df = pd.DataFrame()

            for file_id in files:
                # TBD: File to Text part to be made part of pipeline
                file = File.objects.get(user=request.user, pk=file_id)
                file_path = get_file_path(file)
                file_text = file_to_text(file_path)

                pipeline = Pipeline.objects.get(user=request.user, pk=pipeline_id)

                current_df, schema_df = apply_pipeline_on_text(file_text, pipeline)

                date_cols = df_get_date_columns_by_type(current_df)
                current_df = df_columns_datetime_iso_date_format(current_df, date_cols)

                combined_df = pd.concat([combined_df, current_df])

            response["dataframe_str"] = str(combined_df)
            response["table_json"] = combined_df.to_json(orient='records')
            response["schema"] = schema_df.to_json(orient='records')

        return Response(response)

