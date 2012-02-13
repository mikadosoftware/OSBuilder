


### a clean install of python is nice but will not have all the batteries
### so strip out the eggs on one machine and output shell to get them installed on another
### /usr/local/lib/python2.6/site-packages/easy-install.pth


import sys

if sys.argv[1] == "noversion":
    vers = False
else:
    vers = True

eggs_path = "/usr/local/lib/python2.6/site-packages/easy-install.pth"
for line in open(eggs_path):
    if line.find(".egg") != -1:
        eggname = line.split("-")[0].replace("./", "")
        eggvers = line.split("-")[1]
        if vers:
            eggvers = "==%s" % eggvers
        else:
            eggvers = ""

        print "/usr/local/bin/easy_install %s%s" % (eggname, eggvers)


