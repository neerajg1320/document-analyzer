from rest_framework import viewsets, mixins, renderers
from rest_framework.response import Response
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import action

from core.models import Tag, Extractor, Document, File, Transaction, Schema, Operation, Datastore, Pipeline

from extractor import serializers

from extractor.text_routines import create_highlighted_text, \
    create_transactions_from_text_tuples_str, create_transactions_dict_array_from_text

import pandas as pd

# Used for checking the dtypes
import numpy as np

import json
import hjson
from io import StringIO

from snowflake.sqlalchemy import URL
from sqlalchemy import create_engine


from extractor.pandas_routines import transform_df_using_dict, df_dates_iso_format, \
    df_get_date_columns, df_dates_str, get_columns_info_dataframe

from extractor import excel_routines
from extractor import image_routines

# https://stackoverflow.com/questions/3056048/filename-and-line-number-of-python-script
from inspect import currentframe, getframeinfo

import pyap


# Until supported keep the mapping false for Excel documents
# The flag is manipulated in the FileViewSet::documentize functions
g_flag_process_data = True


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


def save_to_snowflake(df, snowflake_parameters):
    table_name = snowflake_parameters.pop('table')
    snowflake_properties_dict = snowflake_parameters
    db_url = URL(**snowflake_properties_dict)

    save_to_sql(df, db_url, table_name)


def save_to_postgres(df, postgres_parameters):
    table_name = str(postgres_parameters.pop('table')).lower()

    db_url = 'postgresql://' \
             + postgres_parameters['user'] \
             + ':' + postgres_parameters['password'] \
             + '@' + postgres_parameters['host'] \
             + ':' + postgres_parameters['port'] \
             + '/' + postgres_parameters['database']

    save_to_sql(df, db_url, table_name)


def save_to_sql(df, db_url, table_name):
    # frameinfo = getframeinfo(currentframe())
    # print("[{}:{}]:".format(frameinfo.filename, frameinfo.lineno), str(db_url))

    engine = create_engine(db_url)
    try:
        connection = engine.connect()

        # frameinfo = getframeinfo(currentframe())
        # print("[{}:{}]:".format(frameinfo.filename, frameinfo.lineno), "Loading to: %s" % table_name)

        df.to_sql(table_name, engine, index=False, if_exists='append')
        # new_df = pd.read_sql_query('select * from %s' % table_name, con=engine)
        # frameinfo = getframeinfo(currentframe())
        # print("[{}:{}]:".format(frameinfo.filename, frameinfo.lineno), new_df)
    except Exception as e:
        frameinfo = getframeinfo(currentframe())
        print("Exception[{}:{}]:".format(frameinfo.filename, frameinfo.lineno), e)
    finally:
        connection.close()
        engine.dispose()


def load_from_snowflake(snowflake_parameters):
    engine = create_engine(URL(**snowflake_parameters))

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


destination_tables_schema_json = """
    "bank_statement": [
        {"name": "TransactionDate", "type": "object", "aggregation": "none"},
        {"name": "Description", "type": "object", "aggregation": "sum"},
        {"name": "Type", "type": "object", "aggregation": "none"},
        {"name": "Amount", "type": "float64", "aggregation": "sum"}
    ],
    "contract_note": [
        {"name": "TransactionDate", "type": "object", "aggregation": "none"},
        {"name": "SettlementDate", "type": "object", "aggregation": "none"},
        {"name": "Scrip", "type": "object", "aggregation": "sum"},
        {"name": "Quantity", "type": "int64", "aggregation": "sum"},
        {"name": "TradeType", "type": "object", "aggregation": "none"},
        {"name": "Rate", "type": "float64", "aggregation": "none"},
        {"name": "PrincipalAmount", "type": "float64", "aggregation": "sum"},
        {"name": "Commission", "type": "float64", "aggregation": "sum"},
        {"name": "Fees", "type": "float64", "aggregation": "sum"},
        {"name": "NetAmount", "type": "float64", "aggregation": "sum"},
        {"name": "Summary", "type": "object", "aggregation": "sum"}
    ],
    "receipt": [
        {"name": "Date", "type": "object", "aggregation": "none"},
        {"name": "Description", "type": "object", "aggregation": "sum"},
        {"name": "Quantity", "type": "int64", "aggregation": "sum"},
        {"name": "Rate", "type": "float64", "aggregation": "none"},
        {"name": "Amount", "type": "float64", "aggregation": "sum"}
    ],
    "receipt_sno": [
        {"name": "SerialNo", "type": "int64", "aggregation": "none"},
        {"name": "Description", "type": "object", "aggregation": "sum"},
        {"name": "Quantity", "type": "int64", "aggregation": "sum"},
        {"name": "Rate", "type": "float64", "aggregation": "none"},
        {"name": "Amount", "type": "float64", "aggregation": "sum"}
    ]
"""


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

        response_dict = [{
            "regex": regex_str,
            "new_str": new_str,
            # "transactions": transactions_dict_array,
        }]

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

        match_queue = []
        regex_str_dict = {"Transaction": regex_str}
        new_str = replace_regex_with_chars(match_queue, regex_str_dict, complete_text, "Transaction", "-")
        # print(new_str)
        print('\n'.join(map(str, match_queue)))

        transactions_dict_array = create_transactions_dict_array_from_text(regex_str, complete_text)
        # We update the transactions dataframe stored as json
        document.transactions_json = json.dumps(transactions_dict_array)
        super(Document, document).save()

        response_dict = [{
            "new_str": new_str,
            # "dataframe": str(self.get_or_create_transactions_dataframe()),
            "dataframe": str(pd.DataFrame(transactions_dict_array)),
            "transactions": transactions_dict_array,
        }]

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
            # df = df_dates_iso_format(df)
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

    @action(detail=True, renderer_classes=[renderers.JSONRenderer])
    def transactions_get_mapper(self, request, *args, **kwargs):
        document, df = self.get_or_create_transactions_dataframe()

        columns_df = get_columns_info_dataframe(df)
        columns_array = json.loads(columns_df.to_json(orient='records'))

        return Response(columns_array)

    @action(detail=True, renderer_classes=[renderers.JSONRenderer])
    def transactions_post_mapper(self, request, *args, **kwargs):
        document, df = self.get_or_create_transactions_dataframe()

        destination_tables_schema_dict = hjson.loads(destination_tables_schema_json)

        destination_table_name = request.data.get("destination_table", None)

        try:
            destination_table = destination_tables_schema_dict[destination_table_name]
        except KeyError as e:
            frameinfo = getframeinfo(currentframe())
            print("Exception[{}:{}]:".format(frameinfo.filename, frameinfo.lineno),
                  "Key {} does not exist".format(e))
            return Response([])

        # frameinfo = getframeinfo(currentframe())
        # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno),
        #     json.dumps(destination_table, indent=4))

        dst_sch_df = pd.DataFrame(destination_table)
        # frameinfo = getframeinfo(currentframe())
        # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), str(dst_sch_df))

        new_mapper = request.data.get("mapper", None)
        column_mapper_df = pd.DataFrame(json.loads(new_mapper))

        # frameinfo = getframeinfo(currentframe())
        # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), column_mapper_df)

        # New dataframe will only contain columns which are selected
        column_mapper_df = column_mapper_df.loc[column_mapper_df["select"] == True]

        # frameinfo = getframeinfo(currentframe())
        # print("[{}:{}]:".format(frameinfo.filename, frameinfo.lineno), column_mapper_df.dtypes)

        # Find out dst_column to src_column mappings
        dst_column_dict = {}
        for index, row in column_mapper_df.iterrows():
            key = row['dst']
            if dst_column_dict.get(key, None) is None:
                dst_column_dict[key] = []
            dst_column_dict[key].append(row['src'])

        # frameinfo = getframeinfo(currentframe())
        # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), json.dumps(dst_column_dict, indent=2))

        #
        # Aggregate multiple src_columns mapped to same dst_column
        #
        agg_df = pd.DataFrame()
        for dst_col, src_col_list in dst_column_dict.items():
            if len(src_col_list) > 1:
                # https://stackoverflow.com/questions/17071871/select-rows-from-a-dataframe-based-on-values-in-a-column-in-pandas
                subset_df = dst_sch_df.loc[dst_sch_df['name'] == dst_col]
                # frameinfo = getframeinfo(currentframe())
                # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), subset_df)

                # aggregate_fn = 'sum'
                aggregate_fn = subset_df.iloc[0]['aggregation']
                agg_df[dst_col] = df[src_col_list].agg(aggregate_fn, axis="columns")
            else:
                agg_df[dst_col] = df[src_col_list[0]]

        # frameinfo = getframeinfo(currentframe())
        # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), agg_df.columns)

        # Then we assign the new column types
        # https://stackoverflow.com/questions/21197774/assign-pandas-dataframe-column-dtypes
        # Create dictionary from two columns
        # https://stackoverflow.com/questions/17426292/what-is-the-most-efficient-way-to-create-a-dictionary-of-two-pandas-dataframe-co
        new_dtypes_dict = pd.Series(dst_sch_df.type.values, index=dst_sch_df.name).to_dict()
        # frameinfo = getframeinfo(currentframe())
        # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), new_dtypes_dict.keys())

        numeric_columns = []
        numeric_columns += dst_sch_df.loc[dst_sch_df['type'] == 'float64']['name'].tolist()
        numeric_columns += dst_sch_df.loc[dst_sch_df['type'] == 'int64']['name'].tolist()

        # numeric_columns.append(dst_sch_df.loc[dst_sch_df['type'] == 'int64'].name)
        # frameinfo = getframeinfo(currentframe())
        # print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno), numeric_columns)

        for col in numeric_columns:
            try:
                if agg_df[col].dtype == 'object':
                    agg_df[col] = agg_df[col].str.replace(',', '')
            except KeyError as e:
                frameinfo = getframeinfo(currentframe())
                print("[{}:{}]:\n".format(frameinfo.filename, frameinfo.lineno),
                      "KeyError:" + str(e))

        try:
            agg_df = agg_df.astype(dtype=new_dtypes_dict)
        except ValueError as e:
            frameinfo = getframeinfo(currentframe())
            print("Exception[{}:{}]:".format(frameinfo.filename, frameinfo.lineno), e)
        except KeyError as e:
            frameinfo = getframeinfo(currentframe())
            print("Exception[{}:{}]:".format(frameinfo.filename, frameinfo.lineno), e)

        try:
            response_dict = [{
                "mapped_df": str(agg_df),
                "mapped_df_json": agg_df.to_json(orient='records'),
            }]
        except Exception as e:
            response_dict = []

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
            if str(datastore_type).lower() == 'snowflake':
                #  This is the mapping according to the hardcoded regex extractor
                #
                # flag_process_data = g_flag_process_data
                # if flag_process_data:
                #     # Need to be lookup based
                #     groupby_dict = self.get_groupby_dict(document)
                #     df = transform_df_using_dict(df, groupby_dict)
                save_to_snowflake(mapped_df, datastore_parameters)
                # df = load_from_snowflake(datastore_parameters)
            elif str(datastore_type).lower() == 'postgres':
                save_to_postgres(mapped_df, datastore_parameters)

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
                file_transactions_json = text_extract_dataframe_json(file.institute_name,
                                                                     file.document_type,
                                                                     file.text)
                g_flag_process_data = True
            elif excel_routines.is_file_extn_excel(file_extn):
                file.text = excel_routines.excel_to_text(file_path)
                file_transactions_json = excel_routines.excel_to_json(file_path)
                g_flag_process_data = False
            elif image_routines.is_file_extn_image(file_extn):
                file.text = image_routines.image_to_text(file_path)
                g_flag_process_data = True
            else :
                file.text = "Format {} not supported".format(file_extn)

            super(File, file).save()

        # The following code is just for testing purpose
        #
        # addresses = pyap.parse(file.text, country='US')
        # for address in addresses:
        #     frameinfo = getframeinfo(currentframe())
        #     print("[{}:{}]:".format(frameinfo.filename, frameinfo.lineno),
        #           json.dumps(address.as_dict(), indent=4))

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


class DatastoreViewSet(viewsets.ModelViewSet):
    """ Manage documents in database """
    queryset = Datastore.objects.all()

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
            return serializers.DatastoreDetailSerializer

        # return self.serializer_class
        return serializers.DatastoreListSerializer


def file_to_text(file_path, password="password"):
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

        file_id = request.data.get("file_id", None)
        if file_id is None:
            response["error"] = "File id %s not found" % file_id

        if file_id and pipeline_id:
            # TBD: File to Text part to be made part of pipeline
            file = File.objects.get(user=request.user, pk=file_id)
            file_path = get_file_path(file)
            text = file_to_text(file_path)
            print(text)

            pipeline = Pipeline.objects.get(user=request.user, pk=pipeline_id)
            print(pipeline)

            for operation in pipeline.operations.all():
                if operation.type == "Extract":
                    print("Extract:", operation.parameters)
                elif operation.type == "Transform":
                    print("Transform:", operation.parameters)
                elif operation.type == "Load":
                    print("Load:", operation.parameters)
                else:
                    response["error"] = "Operation %s not found" % operation.type

            response["msg"] = "Pipeline implementation under construction"

        return Response(response)
