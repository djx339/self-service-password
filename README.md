self-service-password
=====================

Self Service Password is a PHP application that allows users to change their password in an LDAP directory.

This project forked https://ltb-project.org/svn/self-service-password/trunk/

Changes:
* Replaced the default sendmail with PEAR::MAIL()
* Use HTTP_HOST replaced SERVER_NAME when generate passreset url

Documents
=========

http://ltb-project.org/wiki/documentation/self-service-password
