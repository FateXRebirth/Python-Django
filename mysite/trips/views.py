# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.shortcuts import render

# Create your views here.

from django.http import HttpResponse
from datetime import datetime
from .models import Post

def hello_world(request):
    return render(request, 'hello_world.html', {
        'current_time': str(datetime.now()),
    })

def home(request):
    # post1 = Post(title='My First Trip', content='肚子好餓，吃什麼好呢?',  location='台北火車站')
    # post1.save();
    # post2 = Post(title='My Second Trip', content='去散散步吧',  location='大安森林公園')
    # post2.save();
    # post3 = Post(title='Django 大冒險', content='從靜態到動態',  location='台北市大安區復興南路一段293號')
    # post3.save();
    post_list = Post.objects.all()
    return render(request, 'home.html', {
        'post_list': post_list,
    })