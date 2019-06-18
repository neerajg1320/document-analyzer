from rest_framework import viewsets, mixins, renderers
from rest_framework.response import Response
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import action

from core.models import Tag, Extractor, Document, File

from extractor import serializers

from extractor.text_routines import create_highlighted_text, \
    create_transactions_from_text_tuples_str, create_transactions_dict_array_from_text

import pandas as pd

import json


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
        if document.transactions is None or document.transactions == "" or True:
            # Lookup for the parser(extractor)
            #   based on institure name (e.g. HDFC) and document type (e.g. Savings Statement)
            extractors = Extractor.objects.filter(institute_name__iexact=document.institute_name,
                                                  document_type__iexact=document.document_type)
            if not extractors:
                raise Exception("Extractor not found")

            transaction_regex_str = extractors[0].regex_parser

            # The following will send the table header first and then table rows as values
            document.transactions = create_transactions_from_text_tuples_str(transaction_regex_str, document.text)

            super(Document, document).save()

        highlighted_text = create_highlighted_text(document.transactions, title="Transactions")
        return Response(highlighted_text)

    @action(detail=True, renderer_classes=[renderers.JSONRenderer])
    def transactions_json(self, request, *args, **kwargs):
        document = self.get_object()
        # unconditionally enabled temporarily
        if document.transactions is None or document.transactions == "" or True:
            print("Creating transactions from document.text")
            # Lookup for the parser(extractor)
            #   based on institure name (e.g. HDFC) and document type (e.g. Savings Statement)
            extractors = Extractor.objects.filter(institute_name__iexact=document.institute_name,
                                                  document_type__iexact=document.document_type)
            if not extractors:
                raise Exception("Extractor not found")

            transaction_regex_str = extractors[0].regex_parser

            # The following will send the table header first and then table rows as values
            # document.transactions = create_transactions_from_text_tuples_str(transaction_regex_str, document.text)

            # The following will send the data in json format
            transactions_array = create_transactions_dict_array_from_text(transaction_regex_str, document.text)
            document.transactions = json.dumps(transactions_array)

            super(Document, document).save()
        else:
            print("Loading transaction from document.transactions")
            transactions_array = json.loads(document.transactions)

        # highlighted_text = create_highlighted_text(document.transactions, title="Transactions")
        return Response(transactions_array)

    @action(detail=True, renderer_classes=[renderers.JSONRenderer])
    def transactions_pandas_json(self, request, *args, **kwargs):
        document = self.get_object()
        # unconditionally enabled temporarily
        if document.transactions is None or document.transactions == "" or True:
            print("Creating transactions from document.text")
            # Lookup for the parser(extractor)
            #   based on institure name (e.g. HDFC) and document type (e.g. Savings Statement)
            extractors = Extractor.objects.filter(institute_name__iexact=document.institute_name,
                                                  document_type__iexact=document.document_type)
            if not extractors:
                raise Exception("Extractor not found")

            transaction_regex_str = extractors[0].regex_parser

            # The following will send the table header first and then table rows as values
            # document.transactions = create_transactions_from_text_tuples_str(transaction_regex_str, document.text)

            # The following will send the data in json format
            transactions_array = create_transactions_dict_array_from_text(transaction_regex_str, document.text)
            document.transactions = json.dumps(transactions_array)

            super(Document, document).save()
        else:
            print("Loading transaction from document.transactions")
            transactions_array = json.loads(document.transactions)

        groupby_dict = {'trade_date': 'TradeDate',
                        'trade_type': 'TradeType',
                        'trade_qty': 'TradeQuantity',
                        'principal': 'PrincipalAmount',
                        'net_amount': 'NetAmount',
                        'option': 'Scrip',
                        'symbol': 'Symbol',
                        }

        transactions_array = self.transform_array_using_dict(transactions_array, groupby_dict)

        return Response(transactions_array)

    def transform_array_using_dict(self, transactions_array, mapper_dict):
        df = pd.DataFrame(transactions_array);
        # https://www.geeksforgeeks.org/combining-multiple-columns-in-pandas-groupby-with-dictionary/
        # Here we shall map data

        # Set the index of df as Column 'id'
        # df = df.set_index('id')
        df = df.groupby(mapper_dict, axis=1).sum()

        # Create json from the pandas DataFrame
        transactions_array = json.loads(df.to_json(orient='records'))
        return transactions_array

    # Should use the reverse function
    @action(detail=True, renderer_classes=[renderers.StaticHTMLRenderer])
    def transactions_pandas(self, request, *args, **kwargs):
        document = self.get_object()
        # unconditionally enabled temporarily
        if document.transactions is None or document.transactions == "" or True:
            print("Creating transactions from document.text")
            # Lookup for the parser(extractor)
            #   based on institure name (e.g. HDFC) and document type (e.g. Savings Statement)
            extractors = Extractor.objects.filter(institute_name__iexact=document.institute_name,
                                                  document_type__iexact=document.document_type)
            if not extractors:
                raise Exception("Extractor not found")

            transaction_regex_str = extractors[0].regex_parser

            # The following will send the table header first and then table rows as values
            # document.transactions = create_transactions_from_text_tuples_str(transaction_regex_str, document.text)

            # The following will send the data in json format
            transactions_array = create_transactions_dict_array_from_text(transaction_regex_str, document.text)
            document.transactions = json.dumps(transactions_array)

            super(Document, document).save()
        else:
            print("Loading transaction from document.transactions")
            transactions_array = json.loads(document.transactions)

        df = pd.DataFrame(transactions_array);

        # https://www.geeksforgeeks.org/combining-multiple-columns-in-pandas-groupby-with-dictionary/
        # Here we shall map data
        groupby_dict = {'trade_date': 'TradeDate',
                        'trade_type': 'TradeType',
                        'trade_qty': 'TradeQuantity',
                        'principal': 'PrincipalAmount',
                        'net_amount': 'NetAmount'}

        # Set the index of df as Column 'id'
        # df = df.set_index('id')
        df = df.groupby(groupby_dict, axis=1).sum()

        transactions_pandas_str = str(df)
        print("Pandas DataFrame:\n" + transactions_pandas_str)
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
            self.pdf_file_to_text(file)
            super(File, file).save()

        return Response(file.text)

    @action(detail=True, renderer_classes=[renderers.JSONRenderer])
    def documentize(self, request, *args, **kwargs):
        file = self.get_object()

        if file.text is None or file.text == "" or True:
            self.pdf_file_to_text(file)
            super(File, file).save()

        document = Document.objects.create(user=file.user,
                                           title=file.title,
                                           institute_name=file.institute_name,
                                           document_type=file.document_type,
                                           text=file.text)

        document_serialized = serializers.DocumentDetailSerializer(document)
        return Response(document_serialized.data)

    def pdf_file_to_text(self, file):
        file_path = os.path.join(settings.MEDIA_ROOT, str(file.file))
        if is_encrypted_pdf(file_path):
            print("PDF is encrypted")
            decrypted_file_name = "decrypted_" + str(file.file)
            decrypted_file_path = os.path.join(settings.MEDIA_ROOT, decrypted_file_name)
            decrypt_pdf(file_path, decrypted_file_path, file.password)
            file_path = decrypted_file_path
        # file.text = pdftotext_read_pdf(file_path, file.password)
        file.text = pdftotext_read_pdf_using_subprocess(file_path, file.password)
