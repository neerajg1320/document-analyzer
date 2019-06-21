from rest_framework import viewsets, mixins, renderers
from rest_framework.response import Response
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import action

from core.models import Tag, Extractor, Document, File, Transaction

from extractor import serializers

from extractor.text_routines import create_highlighted_text, \
    create_transactions_from_text_tuples_str, create_transactions_dict_array_from_text

import pandas as pd

import json
import hjson
from io import StringIO

from extractor.pandas_routines import transform_df_using_dict, df_dates_iso_format, \
    df_get_date_columns
from extractor import excel_routines


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

    @action(detail=True, renderer_classes=[renderers.StaticHTMLRenderer])
    def transactions(self, request, *args, **kwargs):
        document = self.get_object()
        # unconditionally enabled temporarily
        if document.transactions_json is None or document.transactions_json == "" or True:
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
            print("Loading transaction from document.transactions_json")
            transactions_array = json.loads(document.transactions_json)

        return document, transactions_array

    @action(detail=True, renderer_classes=[renderers.JSONRenderer])
    def transactions_json(self, request, *args, **kwargs):
        document, transactions_array = self.get_or_create_transactions_array()

        return Response(transactions_array)

    def get_or_create_transactions_dataframe(self):
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
            df = pd.DataFrame(transactions_array)
            document.transactions_json = df.to_json(orient='records')

            super(Document, document).save()
        else:
            print("Loading transaction from document.transactions_json")
            # transactions_array = json.loads(document.transactions_json)
            df = pd.read_json(document.transactions_json)

        return document, df

    def get_groupby_dict(self, document):
        if document.document_type == "ContractNote":
            groupby_dict_json = trade_groupby_json
        elif document.document_type == "CreditCardStatement":
            groupby_dict_json = creditcard_groupby_json

        # hjson.loads makes sure that keys are also strings
        groupby_dict = hjson.loads(groupby_dict_json)

        # print(groupby_dict)

        return groupby_dict

    def create_transactions(self, document, transactions_array):
        for transaction in transactions_array:
            # print(type(transaction), transaction)
            Transaction.objects.create(user=self.request.user, doc=document, **transaction)

    @action(detail=True, renderer_classes=[renderers.JSONRenderer])
    def mapped_transactions_json(self, request, *args, **kwargs):
        document, df = self.get_or_create_transactions_dataframe()

        flag_process_data = True
        flag_create_transactions = False

        if flag_process_data:
            # Need to be lookup based
            groupby_dict = self.get_groupby_dict(document)

            df = transform_df_using_dict(df, groupby_dict)
            df = df_dates_iso_format(df)

        transactions_array = json.loads(df.to_json(orient='records'))

        if flag_create_transactions:
            self.create_transactions(document, transactions_array)

        return Response(transactions_array)

    @action(detail=True, renderer_classes=[renderers.JSONRenderer])
    def mapped_transactions_csv(self, request, *args, **kwargs):
        document, df = self.get_or_create_transactions_dataframe()

        # Need to be lookup based
        groupby_dict = self.get_groupby_dict(document)
        df = transform_df_using_dict(df, groupby_dict)

        # We have to explore if hardcoding or columns can be removed
        # df.columns.values[0] = 'Id'
        # df = df.rename(columns={"": "Id"})

        buf = StringIO()
        df.to_csv(buf, index=False)

        return Response(buf.getvalue())

    # Should use the reverse function
    @action(detail=True, renderer_classes=[renderers.StaticHTMLRenderer])
    def transactions_dataframe(self, request, *args, **kwargs):
        document, df = self.get_or_create_transactions_dataframe()

        # Need to be lookup based
        groupby_dict = self.get_groupby_dict(document)

        df = transform_df_using_dict(df, groupby_dict)

        transactions_pandas_str = str(df)
        return Response(transactions_pandas_str)


from rest_framework.response import Response
from django.conf import settings
import os
from extractor.pdf_routines import read_pdf, is_encrypted_pdf, decrypt_pdf, \
    pdftotext_read_pdf, pdftotext_read_pdf_using_subprocess


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

    def get_file_path(self, file):
        file_path = os.path.join(settings.MEDIA_ROOT, str(file.file))
        return file_path

    @action(detail=True, renderer_classes=[renderers.JSONRenderer])
    def documentize(self, request, *args, **kwargs):
        file = self.get_object()
        file_path = self.get_file_path(file)

        if file.text is None or file.text == "" or True:
            file_name, file_extn = os.path.splitext(file_path)

            if file_extn.lower() == '.pdf':
                file.text = pdftotext_read_pdf_using_subprocess(file_path, file.password)
            elif excel_routines.is_file_extn_excel(file_extn):
                file.text = excel_routines.excel_to_text(file_path)
            else :
                file.text = "Format {} not supported".format(file_extn)

            super(File, file).save()

        document = Document.objects.create(user=file.user,
                                           title=file.title,
                                           institute_name=file.institute_name,
                                           document_type=file.document_type,
                                           text=file.text,)
        print(document)

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
