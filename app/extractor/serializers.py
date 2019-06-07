from rest_framework import serializers

from core.models import Tag, Extractor


class TagSerializer(serializers.ModelSerializer):
    """ Serializer for Tag objects """

    class Meta:
        model = Tag
        fields = ('id', 'name')
        read_only_fields = ('id',)


# The ExtractorSerializer does not show regex_parser.
class ExtractorSerializer(serializers.ModelSerializer):
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
