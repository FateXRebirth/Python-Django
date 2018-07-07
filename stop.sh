#!/usr/bin/env bash
# shut down uwsgi
uwsgi --stop /Users/mac/Desktop/Python-Django/mysite.pid
# gracefully stop nginx
sudo nginx -s quit