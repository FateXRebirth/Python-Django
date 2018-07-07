#!/usr/bin/env bash
ROOT_PATH=`pwd`
NGINX_CONFIG_FILE=python_nginx.conf
NGINX_SITES_CONFIG=/usr/local/etc/nginx/servers
UWSGI_CONFIG_FILE=uwsgi.ini
echo """
# the upstream component nginx needs to connect to
upstream django {
    # server 127.0.0.1:8001;
    server unix:///$ROOT_PATH/mysite.sock; # for a file socket, more effective
}
# configuration of the server
server {
    # the port your site will be served on
    listen      8000;
    server_name localhost;
    charset     utf-8;
    # max upload size
    client_max_body_size 75M;   # adjust to taste
    # Django media
    location /media  {
        alias $ROOT_PATH/mysite/media;  # your Django project's media files - amend as required
    }
    location /static {
        alias $ROOT_PATH/mysite/static; # your Django project's static files - amend as required
    }
    # Finally, send all non-media requests to the Django server.
    location / {
        uwsgi_pass  django;
	    include	$ROOT_PATH/uwsgi_params; # the uwsgi_params file you installed
    }
}
""" > $NGINX_CONFIG_FILE
echo """
# mysite_uwsgi.ini file
[uwsgi]
# Django-related settings
# the base directory (full path)
chdir           = $ROOT_PATH/mysite
# Django's wsgi file
module          = mysite.wsgi

# process-related settings
# master
master          = true
# maximum number of worker processes
processes       = 10
# the socket (use the full path to be safe)
socket          = $ROOT_PATH/mysite.sock
# ... with appropriate permissions - may be needed
chmod-socket    = 664
# clear environment on exit
vacuum          = true
# create a pidfile
pidfile = $ROOT_PATH/mysite.pid
# background the process & log
daemonize = uwsgi.log
""" > $UWSGI_CONFIG_FILE
if [ ! -d "$NGINX_SITES_CONFIG" ]; then
    mkdir -p "$NGINX_SITES_CONFIG"
fi
ln -sf $ROOT_PATH/$NGINX_CONFIG_FILE $NGINX_SITES_CONFIG