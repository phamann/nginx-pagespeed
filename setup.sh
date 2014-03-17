##
# Custom Nginx build with mod_pagespeed support
#
# Adapted from https://index.docker.io/u/gvangool/nginx-src/
# 
##

# Install build tools for nginx
apt-get build-dep nginx-full -y && apt-get install wget unzip curl -y && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add Nginx source repository & signing key
echo "deb http://nginx.org/packages/ubuntu/ precise nginx" >> /etc/apt/sources.list.d/nginx-precise.list
apt-key adv --fetch-keys http://nginx.org/keys/nginx_signing.key
echo "deb-src http://nginx.org/packages/ubuntu/ precise nginx" >> /etc/apt/sources.list.d/nginx-precise.list

# Add vim; we'll be doing do some local mods
apt-get install vim -y

# Install Nginx from a tarball
# Install build tools for nginx
export NGINX_VERSION=1.4.4
export MODULESDIR=/usr/src/nginx-modules
cd /usr/src/ && wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && tar xf nginx-${NGINX_VERSION}.tar.gz && rm -f nginx-${NGINX_VERSION}.tar.gz

# Install additional modules
apt-get install -y build-essential zlib1g-dev libpcre3 libpcre3-dev libgd2-xpm-dev build-essential
mkdir ${MODULESDIR}
cd ${MODULESDIR} && \
	wget --no-check-certificate https://github.com/pagespeed/ngx_pagespeed/archive/v1.7.30.3-beta.zip && \
	unzip v1.7.30.3-beta.zip && \
	cd ngx_pagespeed-1.7.30.3-beta/ && \
	wget --no-check-certificate https://dl.google.com/dl/page-speed/psol/1.7.30.3.tar.gz && \
	tar -xzvf 1.7.30.3.tar.gz

# Compile nginx
cd /usr/src/nginx-${NGINX_VERSION} && ./configure \
	--prefix=/etc/nginx \
	--sbin-path=/usr/sbin/nginx \
	--conf-path=/etc/nginx/nginx.conf \
	--error-log-path=/var/log/nginx/error.log \
	--http-log-path=/var/log/nginx/access.log \
	--pid-path=/var/run/nginx.pid \
	--lock-path=/var/run/nginx.lock \
	--with-http_realip_module \
	--with-http_addition_module \
	--with-http_sub_module \
	--with-http_gunzip_module \
	--with-http_gzip_static_module \
	--with-http_random_index_module \
	--with-http_secure_link_module \
	--with-http_stub_status_module \
	--with-http_image_filter_module \
	--with-ipv6 \
	--add-module=${MODULESDIR}/ngx_pagespeed-1.7.30.3-beta

cd /usr/src/nginx-${NGINX_VERSION} && make && make install

cp /vagrant/nginx/nginx.conf /etc/nginx/nginx.conf

#copy/download/curl/wget the init script
cp /vagrant/nginx/init.sh /etc/init.d/nginx
chmod +x /etc/init.d/nginx

update-rc.d -f nginx defaults

sudo service nginx status  # to poll for current status
sudo service nginx stop    # to stop any servers if any
sudo service nginx start   # to start the server

# Purge APT cache
apt-get clean all
