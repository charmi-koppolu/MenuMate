from django.urls import path
from .views import *

urlpatterns = [
    path("Hello/", func),
    path("user/get_user/<id>", get_user),
    path("user/register/", register_user),
    path("dining/add_dining_hall/", add_dining_hall),
    path("favorites/add_favorite/", add_favorite),
    path("generate_otp/<email>", generate_otp)
]
