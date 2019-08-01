from django.shortcuts import render
from django.http import HttpResponse
# Create your views here.

def index(request):
	return HttpResponse("<a href=http://127.0.0.1:8000/Command><p align=center><font size=20>НАЖМИ НА МЕНЯ!!!</font></p></a>")