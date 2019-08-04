from django.shortcuts import render
from django.http import HttpResponse
# Create your views here.

def index(request):
	#return HttpResponse("<a href=http://127.0.0.1:8000/Command><p align=left><font size=6>Тех.поддержка</font></p></a><br><a href=http://127.0.0.1:8000/Programma><p align=left><font size=6>Администрирование</font></p></a>")
	return render(request, 'Shablonizatot/Administrirovanie.html')
	