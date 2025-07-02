from logging import exception

from django.shortcuts import render
from django.http import HttpResponse
from django.http import JsonResponse
import json
import uuid
import random
import time

from django.forms.models import model_to_dict
from django.views.decorators.csrf import csrf_exempt

from .dining_information import *
from .utility import *
from .email import send_email
from .models import *
from .jwt import *

# Create your views here.
import requests
from email import *

def func(request):
    return HttpResponse("Welcome")

@jwt_required
def get_user(request):
    try:
        uid = uuid.UUID(request.user_id)
        user = Users.objects.get(uid = uid)
        data = {}
        data["username"] = user.uname
        data["password"] = user.password
        data["email"] = user.email
        data["age"] = user.age
        return JsonResponse({"status": "Success", "message": "MenuMate", "data": data}, status=200)
    except Exception as e:
        print(e)
        return JsonResponse({"status": "Error", "message": "no user found"}, status=404)

@csrf_exempt
def register_user(request):
    try:
        data = json.loads(request.body)
        username = data["username"]
        password = data["password"]
        fcm_token = data["fcm_token"]
        email = data["email"]
        age = data["age"]
        try:
            user_entry = Users.objects.get(email=email)
            return JsonResponse({"status": "Error", "message": "email already taken"}, status=400)
        except Exception as e:
            user = Users.objects.create(uname=username, password=password, fcm_token=fcm_token, email=email, age=age)
            return JsonResponse({"status": "Success", "message": str(user)}, status=200)
    except Exception as e:
        print(e)
        return JsonResponse({"status": "Error", "message": "error occurred"}, status=500)

@jwt_required
def get_all_dining_halls(request):
    dining_halls = ['Akers', 'Brody', 'Case', 'Holden', 'Holmes', 'Landon', 'Owen', 'Shaw', 'Snyder Phillips']
    data = {'dining_halls': dining_halls}
    return JsonResponse({"status": "Success", "message": "Dining Halls gotten successfully", "data": data}, status=200)

@jwt_required
def get_dining_hall(request, name):
    menu_items = get_menu_items(name)
    if menu_items == {}:
        return JsonResponse({"status": "Error", "message": "Dining Hall is closed"}, status=404)
    return JsonResponse({"status": "Success", "message": menu_items}, status=200)

def add_dining_hall(request):
    try:
        data = json.loads(request.body)
        dname = data["dname"]
        dining_hall = Dining.objects.create(dname=dname)
        return JsonResponse({"status": "Success", "message": str(dining_hall)}, status=200)
    except Exception as e:
        print(e)
        return JsonResponse({"status": "Error", "message": "error occurred"}, status=500)

@csrf_exempt
@jwt_required
def add_favorite(request):
    try:
        data = json.loads(request.body)
        fname = data["fname"].lower()
        uid = data["uid"]
        uid = uuid.UUID(hex=uid)
        user = Users.objects.get(uid=uid)
        # did = data["did"]
        # did = uuid.UUID(hex=did)
        # dining = Dining.objects.get(did=did)
        favorite = Favorites.objects.create(fname=fname, user=user)
        return JsonResponse({"status": "Success", "message": "favorite added", "fav_info": str(favorite)}, status=200)
    except Exception as e:
        print(e)
        return JsonResponse({"status": "Error", "message": "error occurred"}, status=500)

def generate_otp(request, email):
    try:
        rand_int = str(random.randint(1000, 9999))
        current_time = time.time()
        message = f"Here is your OTP code: {rand_int}"
        subject = "OTP code"

        OTP.objects.update_or_create(email=email,defaults={'code': rand_int, 'created_at_time': int(current_time)})

        send_email(email, message, subject)
        return JsonResponse({"status": "Success", "message": "OTP code sent"}, status=200)
    except Exception as e:
        print(e)
        return JsonResponse({"status": "Error", "message": "error occurred"}, status=500)

def verify_otp(request, email, otp):
    try:
        otp_entry = OTP.objects.get(email=email)
        current_time = time.time()
        if otp_entry.code == otp:
            if int(current_time) - otp_entry.created_at_time < 300:
                return JsonResponse({"status": "Success", "message": "valid OTP"}, status=200)
            else:
                return JsonResponse({"status": "Error", "message": "OTP expired"}, status=400)
        else:
            return JsonResponse({"status": "Error", "message": "unvalid OTP"}, status=401)
    except Exception as e:
        print(e)
        return JsonResponse({"status": "Error", "message": "unvalid email"}, status=404)

@csrf_exempt
def login(request):
    data = json.loads(request.body)
    email = data["email"]
    password = data["password"]
    try:
        user_entry = Users.objects.get(email=email)
        if user_entry.password == password:
            jwt_token = create_jwt(user_entry.uid)
            return JsonResponse({"status": "Success", "message": "login successful", "uid": user_entry.uid, "jwt_token": jwt_token}, status=200)
        else:
            return JsonResponse({"status": "Error", "message": "incorrect password"}, status=401)
    except Exception as e:
        print(e)
        return JsonResponse({"status": "Error", "message": "no user found"}, status=404)

@jwt_required
def delete_user(request):
    try:
        uid = uuid.UUID(request.user_id)
        user_entry = Users.objects.get(uid=uid)
        user_entry.delete()
        return JsonResponse({"status": "Success", "message": "user deletion successful"}, status=200)
    except Exception as e:
        print(e)
        return JsonResponse({"status": "Error", "message": "no user found"}, status=404)

@jwt_required
def delete_favorite(request, id):
    try:
        fid = uuid.UUID(hex=id)
        favorite_entry = Favorites.objects.get(fid=fid)
        favorite_entry.delete()
        return JsonResponse({"status": "Success", "message": "favorite deletion successful"}, status=200)
    except Exception as e:
        print(e)
        return JsonResponse({"status": "Error", "message": "no favorite entry found"}, status=404)

@jwt_required
def update_user(request):
    try:
        uid = uuid.UUID(request.user_id)
        user = update_user_info(request, uid)
        return JsonResponse({"status": "Success", "message": "user updated", "user_info": str(user)}, status=200)
    except Users.DoesNotExist:
        return JsonResponse({"status": "Error", "message": "user not found"}, status=404)
    except Exception as e:
        print(e)
        return JsonResponse({"status": "Error", "message": "update failed"}, status=500)

@jwt_required
def update_favorite(request, id):
    try:
        fid = uuid.UUID(hex=id)
        favorite_entry = Favorites.objects.get(fid=fid)
        data = json.loads(request.body)
        fname = data.get("fname")
        if fname:
            favorite_entry.fname = fname
        # did = data.get("did")
        # if did:
        #     did = uuid.UUID(hex=did)
        #     favorite_entry.did = did
        favorite_entry.save()
        return JsonResponse({"status": "Success", "message": "favorite updated"}, status=200)
    except Exception as e:
        print(e)
        return JsonResponse({"status": "Error", "message": "no favorite entry found"}, status=404)

@jwt_required
def get_favorite(request, id):
    try:
        fid = uuid.UUID(hex=id)
        favorite_entry = Favorites.objects.get(fid=fid)
        fav_entry = {}
        fav_entry["fid"] = favorite_entry.fid
        fav_entry["fname"] = favorite_entry.fname
        #fav_entry["dining"] = model_to_dict(favorite_entry.dining)
        fav_entry["user"] = model_to_dict(favorite_entry.user)
        return JsonResponse({"status": "Success", "message": "favorite", "data": fav_entry}, status=200)
    except Exception as e:
        print(e)
        return JsonResponse({"status": "Error", "message": "no favorite entry found"}, status=404)

@jwt_required
def get_all_favorites(request):
    try:
        uid = uuid.UUID(request.user_id)
        user = Users.objects.get(uid=uid)
        all_favorites = Favorites.objects.filter(user=user)
        favs = []
        for favorite_entry in all_favorites:
            fav_entry = {}
            fav_entry["fid"] = favorite_entry.fid
            fav_entry["fname"] = favorite_entry.fname
            #fav_entry["dining"] = model_to_dict(favorite_entry.dining)
            fav_entry["user"] = model_to_dict(favorite_entry.user)
            favs.append(fav_entry)
        return JsonResponse({"status": "Success", "message": "all favorites", "data": favs}, status=200)
    except Exception as e:
        print(e)
        return JsonResponse({"status": "Error", "message": "no favorite entry found"}, status=404)
