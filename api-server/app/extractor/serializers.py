from rest_framework import serializers

from core.models import Tag, Extractor, Document


class TagSerializer(serializers.ModelSerializer):
    """ Serializer for Tag objects """

    class Meta:
        model = Tag
        fields = ('id', 'name')
        read_only_fields = ('id',)


# The ExtractorSerializer does not show regex_parser.
class ExtractorListSerializer(serializers.ModelSerializer):
    """ Serializer for Extractor objects """

    class Meta:
        model = Extractor
        fields = ('id', 'title', 'institute_name', 'document_type',
                  'reference')
        read_only_fields = ('id',)


# The ExtractorDetailSerializer shows regex_parser as well.
class ExtractorDetailSerializer(serializers.ModelSerializer):
    """ Serializer for Extractor objects """

    class Meta:
        model = Extractor
        fields = ('id', 'title', 'institute_name', 'document_type',
                  'regex_parser', 'reference')
        read_only_fields = ('id',)


# The DocumentSerializer does not show regex_parser.
class DocumentListSerializer(serializers.ModelSerializer):
    """ Serializer for Document objects """

    class Meta:
        model = Document
        fields = ('id', 'title', 'institute_name', 'document_type')
        read_only_fields = ('id',)


# The DocumentDetailSerializer shows regex_parser as well.
class DocumentDetailSerializer(serializers.ModelSerializer):
    """ Serializer for Document objects """

    class Meta:
        model = Document
        # NG: 2019-06-13 3:34pm
        # We will not provide highlight and transactions by default.
        # This will keep our API clean and also can potentially help us in accounting.
        # But we need to watch out for any side effects.
        #
        # fields = ('id', 'title', 'institute_name', 'document_type', 'text', 'highlighted', 'transactions')
        fields = ('id', 'title', 'institute_name', 'document_type', 'text',)
        read_only_fields = ('id', 'highlighted',)
