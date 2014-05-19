xorg:
    pkg.installed:
        - pkgs:
            - xorg-server
            - xorg-drivers
            - xinit
            - xf86-input-keyboard
            - xf86-input-mouse

/etc/X11/xorg.conf:
    file.managed:
        - source:
            - salt://xorg/xorg.conf

