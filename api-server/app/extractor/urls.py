from django.urls import path, include
from rest_framework.routers import DefaultRouter

from extractor import views
from rest_framework import renderers

router = DefaultRouter()
router.register('tags', views.TagViewSet)
router.register('extractors', views.ExtractorViewSet)
router.register('documents', views.DocumentViewSet)
router.register('files', views.FileViewSet)

app_name = 'extractor'

document_highlight = views.DocumentViewSet.as_view({
    'get': 'highlight'
}, renderer_classes=[renderers.StaticHTMLRenderer, renderers.JSONRenderer])

document_transactions = views.DocumentViewSet.as_view({
    'get': 'transactions'
}, renderer_classes=[renderers.StaticHTMLRenderer])

document_transactions_json = views.DocumentViewSet.as_view({
    'get': 'transactions_json'
}, renderer_classes=[renderers.JSONRenderer])

document_transactions_pandas = views.DocumentViewSet.as_view({
    'get': 'transactions_pandas'
}, renderer_classes=[renderers.JSONRenderer])


file_textify = views.FileViewSet.as_view({
    'get': 'textify'
}, renderer_classes=[renderers.StaticHTMLRenderer, renderers.JSONRenderer])


urlpatterns = [
    path('', include(router.urls)),

    path('documents/<int:pk>/highlight/', document_highlight, name='document-highlight'),
    path('documents/<int:pk>/transactions/', document_transactions, name='document-transactions'),
    path('documents/<int:pk>/transactions/json/', document_transactions_json, name='document-transactions-json'),
    path('documents/<int:pk>/transactions/pandas/', document_transactions_pandas, name='document-transactions-json'),

    path('files/<int:pk>/textify/', file_textify, name='file-textify'),
]
