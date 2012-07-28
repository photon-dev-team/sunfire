Requirements
---------------------------

This app require two small changes in ICS and jellybean :

  - This commit : http://review.cyanogenmod.com/19249

  - and in init.rc, you need to create the folder /data/local/hwui.deny
and set his owner to system user

Eclipse
---------------------------

Please use master branch to edit the project in eclipse. ics and jellybean branches
are made to build in a repo environment, just type "mm -B" in the folder to compile the 
application.

