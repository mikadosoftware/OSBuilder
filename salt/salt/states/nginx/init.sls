nginx:
    pkg:
        - installed
    service:
        - running
        - enable: True
        - require: 
            - pkg: nginx
        - watch:
            - file: /usr/local/etc/nginx/nginx.conf

/usr/local/etc/nginx/nginx.conf:
    file.managed:
        - source: salt://nginx/nginx.conf

