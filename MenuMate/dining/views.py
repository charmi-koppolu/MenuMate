from logging import exception

from django.shortcuts import render
from django.http import HttpResponse
from django.http import JsonResponse
import json
import uuid
import random

from .email import send_email
from .models import *

# Create your views here.
import requests
from email import *

def func(request):
    return HttpResponse("Welcome")

def get_user(request, id):
    try:
        id = uuid.UUID(hex = id)
        user = Users.objects.get(uid = id)
        data = {}
        data["username"] = user.uname
        data["password"] = user.password
        data["email"] = user.email
        data["age"] = user.age
        return JsonResponse({"status": "Success", "message": "MenuMate", "user_info": data}, status=200)
    except Exception as e:
        print(e)
        return JsonResponse({"status": "Error", "message": "error occurred"}, status=400)

def register_user(request):
    try:
        data = json.loads(request.body)
        username = data["username"]
        password = data["password"]
        token = data["token"]
        email = data["email"]
        age = data["age"]
        user = Users.objects.create(uname=username, password=password, token=token, email=email, age=age)
        return JsonResponse({"status": "Success", "message": str(user)}, status=200)
    except Exception as e:
        print(e)
        return JsonResponse({"status": "Error", "message": "error occurred"}, status=400)

def add_dining_hall(request):
    try:
        data = json.loads(request.body)
        dname = data["dname"]
        dining_hall = Dining.objects.create(dname=dname)
        return JsonResponse({"status": "Success", "message": str(dining_hall)}, status=200)
    except Exception as e:
        print(e)
        return JsonResponse({"status": "Error", "message": "error occurred"}, status=400)

def add_favorite(request):
    try:
        data = json.loads(request.body)
        fname = data["fname"]
        uid = data["uid"]
        uid = uuid.UUID(hex=uid)
        user = Users.objects.get(uid=uid)
        did = data["did"]
        did = uuid.UUID(hex=did)
        dining = Dining.objects.get(did=did)
        favorite = Favorites.objects.create(fname=fname, user=user, dining=dining)
        return JsonResponse({"status": "Success", "message": "MenuMate", "fav_info": str(favorite)}, status=200)
    except Exception as e:
        print(e)
        return JsonResponse({"status": "Error", "message": "error occurred"}, status=400)

def generate_otp(request, email):
    try:
        rand_int = str(random.randint(1000, 9999))
        message = f"Here is your OTP code: {rand_int}"
        subject = "OTP code"
        get_email = Users.objects.get(email=email)
        print(get_email)
        send_email(email, message, subject)
        return JsonResponse({"status": "Success", "message": "OTP code sent"}, status=200)
    except Exception as e:
        print(e)
        return JsonResponse({"status": "Error", "message": "error occurred"}, status=400)