from logging import exception

from django.shortcuts import render
from django.http import HttpResponse
from django.http import JsonResponse
import json
from .models import *

# Create your views here.
import requests

def func(request):
    return HttpResponse("Welcome")

def func1(request, message):
    print(message)
    return JsonResponse({"status": "Success", "message": "MenuMate"}, status=200)

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

