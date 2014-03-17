nginx-pagespeed
===============

Simple Vagrant wrapper for nginx with the image_filter and pagespeed modules

To install run ```vagrant up``` from the project root.

You will then be able to hit the nginx server from your host machine at ```localhost:8080```

To edit the nginx config, jump onto the box ```vagrant ssh``` and ```vim /etc/nginx/nginx.conf```. Then run ```service nginx restart``` to reload the config.
