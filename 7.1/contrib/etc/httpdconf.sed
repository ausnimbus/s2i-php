s/^Listen 80/Listen 0.0.0.0:8080/
s/^User apache/User default/
s/^Group apache/Group root/
s%^DocumentRoot "/var/www/localhost/htdocs"%#DocumentRoot "/opt/app-root/src"%
s%^<Directory "/var/www/localhost/htdocs"%<Directory "/opt/app-root/src"%
s%^ErrorLog logs/error.log%ErrorLog /dev/stderr%
s%CustomLog logs/access.log combined%CustomLog /dev/stdout combined%

s|^#LoadModule slotmem_shm_module modules/mod_slotmem_shm.so|LoadModule slotmem_shm_module modules/mod_slotmem_shm.so|g
s|^#LoadModule rewrite_module modules/mod_rewrite.so|LoadModule rewrite_module modules/mod_rewrite.so|g

262s%AllowOverride None%AllowOverride All%
