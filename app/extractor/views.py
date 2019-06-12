from rest_framework import viewsets, mixins
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated

from core.models import Tag, Extractor, Document

from extractor import serializers


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


from rest_framework import renderers
from rest_framework.response import Response
from rest_framework import generics

from extractor.text_routines import create_highlighted_text, \
    create_transactions_from_text_tuples_str, create_transactions_dict_array_from_text

import json

class DocumentHighlight(generics.GenericAPIView):
    queryset = Document.objects.all()
    renderer_classes = (renderers.StaticHTMLRenderer,)

    def get(self, request, *args, **kwargs):
        document = self.get_object()
        if document.highlighted is None or document.highlighted == "":
            document.highlighted = create_highlighted_text(document.text, title=document.title)
            super(Document, document).save()
        return Response(document.highlighted)


class DocumentTransactions(generics.GenericAPIView):
    queryset = Document.objects.all()
    renderer_classes = (renderers.StaticHTMLRenderer,)

    def get(self, request, *args, **kwargs):
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
            # document.transactions = create_transactions_from_text_tuples_str(transaction_regex_str, document.text)

            # The following will send the data in json format
            document.transactions = json.dumps(create_transactions_dict_array_from_text(transaction_regex_str, document.text), indent=4)

            super(Document, document).save()

        highlighted_text = document.transactions
        # highlighted_text = create_highlighted_text(document.transactions, title="Transactions")
        return Response(highlighted_text)
