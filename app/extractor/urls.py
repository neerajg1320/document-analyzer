from django.urls import path, include
from rest_framework.routers import DefaultRouter

from extractor import views


router = DefaultRouter()
router.register('tags', views.TagViewSet)

app_name = 'extractor'

urlpatterns = [
    path('', include(router.urls))
]
