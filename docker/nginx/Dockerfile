FROM nginx:1.19
ADD ./docker/nginx/nginx.conf /etc/nginx/
ADD ./docker/nginx/apps.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /var/www/app
ADD ./app/web /var/www/app