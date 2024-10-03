lcopy oneshot
================
::
   
    $ ./srpmix7 expand --stype file --sloc ~/var/upstream/lcopy.d/p/podman.lcopy --dtype dir --dloc /tmp/A lcopy 
    $ ls /tmp/A
    archives  _bundles  info  _log.tar.xz  pre-build  _status  SUCCESSFUL  _uname

lcopy bulk
================
::

   # ./srpmix7 lcopy-deploy -/ /srv/sources ~/var/upstream/lcopy.d
   # chown -R yamato:yamato /srv/sources/sources/*/*/\^lcopy/archives
