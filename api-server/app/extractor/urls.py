from django.urls import path, include
from rest_framework.routers import DefaultRouter

from extractor import views
from rest_framework import renderers

router = DefaultRouter()
router.register('tags', views.TagViewSet)
router.register('extractors', views.ExtractorViewSet)
router.register('documents', views.DocumentViewSet)
router.register('files', views.FileViewSet)
router.register('transactions', views.TransactionViewSet)
router.register('schemas', views.SchemaViewSet)
router.register('operations', views.OperationViewSet)
router.register('datastoretypes', views.DatastoreTypeViewSet)
router.register('pipelines', views.PipelineViewSet)


app_name = 'extractor'


document_highlight = views.DocumentViewSet.as_view({
    'get': 'highlight'
}, renderer_classes=[renderers.StaticHTMLRenderer, renderers.JSONRenderer])

document_regex_create = views.DocumentViewSet.as_view({
    'post': 'regex_create'
}, renderer_classes=[renderers.StaticHTMLRenderer, renderers.JSONRenderer])

document_regex_apply = views.DocumentViewSet.as_view({
    'post': 'regex_apply'
}, renderer_classes=[renderers.StaticHTMLRenderer, renderers.JSONRenderer])

document_transactions = views.DocumentViewSet.as_view({
    'get': 'transactions'
}, renderer_classes=[renderers.StaticHTMLRenderer])

document_transactions_json = views.DocumentViewSet.as_view({
    'get': 'mapped_transactions_json'
}, renderer_classes=[renderers.JSONRenderer])

document_transactions_csv = views.DocumentViewSet.as_view({
    'get': 'mapped_transactions_csv'
}, renderer_classes=[renderers.JSONRenderer])


document_transactions_dataframe = views.DocumentViewSet.as_view({
    'get': 'transactions_dataframe'
}, renderer_classes=[renderers.JSONRenderer])

document_transactions_html = views.DocumentViewSet.as_view({
    'get': 'transactions_html'
}, renderer_classes=[renderers.StaticHTMLRenderer])

document_transactions_mapper = views.DocumentViewSet.as_view({
    'get': 'transactions_get_mapper',
    'post': 'transactions_post_mapper'
}, renderer_classes=[renderers.JSONRenderer])


document_transactions_save = views.DocumentViewSet.as_view({
    'get': 'transactions_save',
    'post': 'transactions_save'
}, renderer_classes=[renderers.JSONRenderer])

operation_loader_get_tables = views.OperationViewSet.as_view({
    'get': 'get_loader_tables'
}, renderer_classes=[renderers.JSONRenderer])


file_textify = views.FileViewSet.as_view({
    'get': 'textify'
}, renderer_classes=[renderers.StaticHTMLRenderer, renderers.JSONRenderer])

pipeline_apply = views.PipelineViewSet.as_view({
    'post': 'apply'
}, renderer_classes=[renderers.StaticHTMLRenderer, renderers.JSONRenderer])



urlpatterns = [
    path('', include(router.urls)),

    path('documents/<int:pk>/highlight/', document_highlight, name='document-highlight'),

    path('documents/<int:pk>/regex/create/', document_regex_create, name='document-regex-create'),
    path('documents/<int:pk>/regex/apply/', document_regex_apply, name='document-regex-apply'),

    path('documents/<int:pk>/transactions/', document_transactions, name='document-transactions'),
    path('documents/<int:pk>/transactions/json/', document_transactions_json, name='document-transactions-json'),
    path('documents/<int:pk>/transactions/csv/', document_transactions_csv, name='document-transactions-csv'),
    path('documents/<int:pk>/transactions/dataframe/', document_transactions_dataframe, name='document-transactions-dataframe'),
    path('documents/<int:pk>/transactions/html/', document_transactions_html, name='document-transactions-html'),
    path('documents/<int:pk>/transactions/mapper/', document_transactions_mapper, name='document-transactions-mapper'),

    path('operations/<int:pk>/loader/tables/', operation_loader_get_tables, name='datastore-get-tables'),

    # This will create the transactions in the transactions table
    # Currently we are saving to snowflake
    path('documents/<int:pk>/transactions/save/', document_transactions_save,
         name='document-transactions-save'),

    path('files/<int:pk>/textify/', file_textify, name='file-textify'),

    path('pipelines/apply/', pipeline_apply, name='pipeline-apply'),
]
