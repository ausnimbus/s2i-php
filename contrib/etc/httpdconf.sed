s/Listen 80/Listen 0.0.0.0:8080/
s/User .*/User default/
s/Group .*/Group root/

s%DocumentRoot .*%#DocumentRoot "/opt/app-root/src"%

s%ErrorLog .*%ErrorLog "|/bin/cat"%
s%CustomLog .*%CustomLog "|/bin/cat" common%

s%Mutex file:.*%Mutex file:/lock/apache2/ default%
s%PidFile .*%Pidfile /run/apache2/apache2.pid%
