from django.shortcuts import render
from django.http import HttpResponse

# Create your views here.
import requests

def func(request):
    return HttpResponse("Welcome")