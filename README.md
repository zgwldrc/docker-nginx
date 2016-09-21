# docker-nginx
install location: /usr/local/nginx/
conf location: /usr/local/nginx/conf
logs location: /usr/local/nginx/logs

with supervisor as start manager
with self crontab and able to logrotate logs in /usr/local/nginx/logs/*.log every day at 00:00
