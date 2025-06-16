from django.urls import path
from .views import *

urlpatterns = [
    path("Hello/", func),
    path("message/<str:message>", func1),
    path("user/register/", register_user),
    path("dining/add_dining_hall/", add_dining_hall)
]
