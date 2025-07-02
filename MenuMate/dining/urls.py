from django.urls import path
from .views import *

urlpatterns = [
    path("Hello/", func),
    path("user/get_user/", get_user),
    path("user/register/", register_user),
    path("dining/get_dining_hall/<name>", get_dining_hall),
    path("dining/get_all_dining_halls/", get_all_dining_halls),
    path("dining/add_dining_hall/", add_dining_hall),
    path("favorites/add_favorite/", add_favorite),
    path("generate_otp/<email>", generate_otp),
    path("verify_otp/<email>/<otp>", verify_otp),
    path("user/login/", login),
    path("user/delete/", delete_user),
    path("favorites/delete/<id>", delete_favorite),
    path("user/update/", update_user),
    path("favorites/update/<id>", update_favorite),
    path("favorites/get_favorite/<id>", get_favorite),
    path("favorites/get_all_favorites/", get_all_favorites)
]
