# docker-nginx
###Deploy Script:
    mkdir nginx && cd nginx && curl sh.xiayu.site/docker/nginx/deploy.sh|bash
##install: /usr/local/nginx/
##conf:    /usr/local/nginx/conf
##logs:    /usr/local/nginx/logs
##static:  /usr/local/nginx/static
##html:    /usr/local/nginx/html

## with supervisor as start manager
## with self crontab and able to logrotate logs in /usr/local/nginx/logs/*.log every day at 00:00
    
    
    version: "2"
    services:
        nginx:
            build: ./
            ####NET WORK SETTING
            ## if set this network mode ,container will use host's /etc/hosts file
            #network_mode: "host"
            #extra_hosts:
            #  - "<hostname>:<ipaddr>"
            ## bridge mode and port mapping
            ports:
                - "8080:80"
            ####VOLUMES SETTING
            volumes:
                - ./conf:/usr/local/nginx/conf
                - ./html:/usr/local/nginx/html
                - ./static:/usr/local/nginx/static
                - ./ssl:/usr/local/nginx/ssl
                - ./logs:/usr/local/nginx/logs
                - ./cache:/usr/local/nginx/cache
            ####SYSTEM SETTING
            ulimits:
                nproc: 65535
                nofile: 65535
            logging:
                options:
                    max-size: "11m"
                    max-file: "7"
            restart: always
