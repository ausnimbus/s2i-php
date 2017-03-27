FROM php:5.6-fpm-alpine
MAINTAINER AusNimbus <support@ausnimbus.com.au>

EXPOSE 8080

ENV STI_SCRIPTS_PATH=/usr/libexec/s2i \
    HOME=/opt/app-root/src

LABEL io.openshift.s2i.scripts-url=image:///usr/libexec/s2i

RUN apk add --update bash python git && rm -rf /var/cache/apk/* && \
    mkdir -p ${HOME}/.pki/nssdb && \
    chown -R 1001:0 ${HOME}/.pki && \
    adduser -S -u 1001 -G root -h ${HOME} -s /sbin/nologin \
      -g "Default Application User" default && \
    chown -R 1001:0 /opt/app-root

# Copy executable utilities.
COPY bin/ /usr/bin/

LABEL io.k8s.description="Platform for building and running PHP 5.6 applications" \
      io.k8s.display-name="Apache 2.4 with PHP 5.6" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,php,php56"

RUN set -xe; \
      apk add --no-cache --virtual .php-builddeps \
        zlib-dev \
        freetype-dev \
        jpeg-dev \
        libjpeg-turbo-dev \
        postgresql-dev \
        sqlite-dev \
        libltdl \
        libmcrypt \
        libmcrypt-dev \
        libpng \
        libpng-dev \
        icu \
        icu-dev \
        gettext-dev \
        libxml2-dev \
        freetype-dev \
        unzip \
        libc6-compat \
        gcc \
        autoconf && \
      docker-php-ext-configure gd --with-freetype-dir=/usr/include/  --with-jpeg-dir=/usr/include/ && \
      docker-php-ext-install \
        bcmath \
        ctype \
        dom \
        fileinfo \
        gd \
        gettext \
        intl \
        json \
        mbstring \
        mcrypt \
        mysqli \
        opcache \
        pcntl \
        pdo \
        pdo_sqlite \
        pdo_mysql \
        pdo_pgsql \
        phar \
        simplexml \
        soap \
        xml \
        zip && \
    	apk add --no-cache apache2-proxy sed gettext && \
      rm -rf /tmp/* && \
      rm -rf /var/cache/apk/*

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Each language image can have 'contrib' a directory with extra files needed to
# run and build the applications.
COPY ./contrib/ /opt/app-root

# Directory with the sources is set as the working directory so all STI scripts
# can execute relative to this path.
WORKDIR ${HOME}

# Drop the root user and make the content of /opt/app-root owned by user 1001
# In order to drop the root user, we have to make some directories world
# writeable as OpenShift default security model is to run the container under
# random UID.
RUN sed -i -f /opt/app-root/etc/httpdconf.sed /etc/apache2/httpd.conf && \
    echo "IncludeOptional /opt/app-root/etc/conf.d/*.conf" >> /etc/apache2/httpd.conf && \
    rm -f /usr/local/etc/php-fpm.d/zz-docker.conf && \
    mkdir /run/apache2 /tmp/sessions /run/php-fpm && \
    chown -R 1001:0 /opt/app-root /tmp/sessions /run/apache2 /run/php-fpm && \
    chmod -R a+rwx /tmp/sessions /run/apache2 /run/php-fpm \
                   /usr/local/etc/php /usr/local/etc/php-fpm.d/ && \
    chmod -R ug+rwx /opt/app-root

USER 1001

CMD $STI_SCRIPTS_PATH/usage
ENTRYPOINT ["container-entrypoint"]
