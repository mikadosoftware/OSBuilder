:desc: Build FreeBSD systems from scratch

=========
OSBUILDER
=========

Building FreeBSD installs from scratch.
=======================================

It is nearly 2014, and this system has built my personal workstations
and a fair number of production / development servers for many years.

However, it is showing its age (the code here still tries to use `CVS` for
heaven's sake.) So I am revamping it, into the modern age of ... `saltstack`

The aim is still the same - to build a viable, usable FreeBSD workstation 
that allows me to "just get on with it".


A few sidenotes
---------------

I have a few "must haves", a few "really really must haves" and 
a couple of "OMG, I will die without".

I discuss these here.

A workstation is no longer the be-all and end-all of a developer's world.
The Personal Computer has given in to the Personal "Network is the Computer"
and that has made many things more awkward as well as more valuable.

Basically that means I am not giving up my smartphone and need access to all
my stuff on several different machines.  Which complicates life.

I also want to have a degree of expected security.


So I want :


* Secure-ish
* Reliable
* Mobile
* Configurable

General idea:

* use `freebsd-update` to keep the base system right
* proper firewall use
* use salt-stack to manage the application / ports layer


First steps
-----------

Install FreeBSD from .img
COnfigure networking

Next Steps
----------

Build minimal `salt-ready` environment
::

   ports fetch
   build git, python
   install salt
   run the minions

Easy way:

   pkg_add -r python
   



List of things on the Laptop
----------------------------

* Latest, security patched, BSD sources / binaries for Kernel and Userland
* Well thought out and configured third-party applications
* A sensible way to manage those applications

List of things strongly connected to the Laptop
-----------------------------------------------

* GSM->Ethernet adaptor
* Wifi (Gulp - me, BSD and WiFi do not mix well)
* X
* emacs, ansi-colour terminals


List of other things
--------------------

* contact management solution
* VoIP / Skype




Bibliography
------------
  
http://blog.mikadosoftware.com/2013/09/17/help-i-cannot-find-a-contact-manager-that-manages-my-contacts/

http://jcooney.net/archive/2007/02/01/42999.aspx.  Its funny. see also http://www.codinghorror.com/blog/archives/000818.html. 

http://en.wikipedia.org/wiki/Feature_interaction_problem - which is referenced from the wise article - http://the-programmers-stone.com/2008/06/23/dirty-little-secrets-response-to-grady-booch/
