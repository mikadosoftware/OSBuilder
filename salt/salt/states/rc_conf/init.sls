/etc/rc.conf:
    file.managed:
        - source:
            - salt://rc_conf/rc.conf

