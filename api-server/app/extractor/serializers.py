from rest_framework import serializers

from core.models import Tag, Extractor, Document, File, Transaction, Schema, Operation, Datastore, Pipeline


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


class TransactionListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Transaction
        fields = '__all__'


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
    transactions = serializers.PrimaryKeyRelatedField(many=True, read_only=True)
    # transactions = serializers.StringRelatedField(many=True)
    # transactions = serializers.HyperlinkedRelatedField(many=True, read_only=True, view_name='transaction-list')

    class Meta:
        model = Document
        # NG: 2019-06-13 3:34pm
        # We will not provide highlight and transactions by default.
        # This will keep our API clean and also can potentially help us in accounting.
        # But we need to watch out for any side effects.
        #
        # fields = ('id', 'title', 'institute_name', 'document_type', 'text', 'highlighted', 'transactions')
        fields = ('id', 'title', 'institute_name', 'document_type', 'text', 'transactions_json', 'transactions',)
        read_only_fields = ('id', 'highlighted', 'transactions',)


class FileListSerializer(serializers.ModelSerializer):
    class Meta():
        model = File
        fields = ('id', 'title', 'institute_name', 'document_type',
                  'file', 'remark', 'timestamp')
        read_only_fields = ('id',)


class FileDetailSerializer(serializers.ModelSerializer):
    class Meta():
        model = File
        fields = ('id', 'title', 'institute_name', 'document_type',
                  'file', 'password', 'text', 'remark', 'timestamp')
        read_only_fields = ('id', 'text')


class SchemaListSerializer(serializers.ModelSerializer):
    class Meta():
        model = Schema
        fields = ('id', 'title', 'fields_json',)
        read_only_fields = ('id',)


class SchemaDetailSerializer(serializers.ModelSerializer):
    class Meta():
        model = Schema
        fields = ('id', 'title', 'fields_json',)
        read_only_fields = ('id',)


class OperationListSerializer(serializers.ModelSerializer):
    class Meta():
        model = Operation
        fields = ('id', 'title', 'type', 'parameters')
        read_only_fields = ('id',)


class OperationDetailSerializer(serializers.ModelSerializer):
    class Meta():
        model = Operation
        fields = ('id', 'title', 'type', 'parameters')
        read_only_fields = ('id',)


class DatastoreListSerializer(serializers.ModelSerializer):
    class Meta():
        model = Datastore
        fields = ('id', 'title', 'parameters')
        read_only_fields = ('id',)


class DatastoreDetailSerializer(serializers.ModelSerializer):
    class Meta():
        model = Datastore
        fields = ('id', 'title', 'parameters')
        read_only_fields = ('id',)


class PipelineSerializer(serializers.ModelSerializer):
    """ Serializer for Recipe objects """
    operations = serializers.PrimaryKeyRelatedField(
        many=True,
        queryset=Operation.objects.all()
    )

    class Meta:
        model = Pipeline
        fields = ('id', 'title', 'institute_name', 'document_type', 'operations')
        read_only_fields = ('id',)


class PipelineDetailSerializer(PipelineSerializer):
    """ Serialize a recipe detail """
    operations = OperationListSerializer(many=True, read_only=True)
