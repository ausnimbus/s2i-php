#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "./hack/run update"
#
# DO NOT EDIT IT DIRECTLY.
#
FROM php:7.1-fpm-alpine
# <pre>

MAINTAINER AusNimbus <support@ausnimbus.com.au>

LABEL summary="Platform for running PHP 7.1 applications" \
      maintainer="AusNimbus <support@ausnimbus.com.au>" \
      io.k8s.description="Platform for running PHP 7.1 applications" \
      io.k8s.display-name="PHP 7.1"

ENV USER=100 \
    HOME=/opt/app-root/src

USER 0

RUN apk --no-cache add bash rsync && \
    ln -sf /bin/bash /bin/sh && \
    mkdir -p $HOME && \
    adduser -S -u 1001 -G root -h $HOME -s /sbin/nologin \
      -g "Default Application User" default && \
    chown -R 1001:0 /opt/app-root

# Copy common executable utilities.
COPY ./common/bin/ /usr/bin/

# Each container image can have 'contrib' a directory with extra files needed to
# run and build the application.
COPY ./contrib/ /opt/app-root

# </pre>
# <s2i>

RUN apk --no-cache add git && rm -rf /var/cache/apk/*

ENV STI_SCRIPTS_PATH=/usr/libexec/s2i

LABEL io.openshift.expose-services="8080:http" \
    io.openshift.tags="builder,php" \
    io.openshift.s2i.scripts-url=image:///usr/libexec/s2i

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Directory with the sources is set as the working directory so all S2I scripts
# can execute relative to this path.
WORKDIR ${HOME}

EXPOSE 8080
CMD /usr/bin/base-usage

# </s2i>
# <template>

RUN set -xe; \
    buildDeps=" \
      build-base \
      pcre-dev \
      curl-dev \
      libedit-dev \
      openssl-dev" && \
    phpDeps=" \
      coreutils \
      gettext \
      gettext-dev \
      libc6-compat \
      icu \
      icu-dev \
      libxml2-dev \
      zlib-dev \
      libpq \
      postgresql-dev \
      mariadb-libs \
      mariadb-dev \
      memcached-dev \
      sqlite-libs \
      sqlite-dev \
      libmcrypt \
      libmcrypt-dev \
      freetype \
      freetype-dev \
      jpeg-dev \
      libjpeg-turbo \
      libjpeg-turbo-dev \
      libpng \
      libpng-dev \
      gd-dev \
      libltdl \
      unzip" && \
    apk add --no-cache apache2 apache2-proxy $phpDeps $buildDeps && \
    docker-php-ext-install -j$(nproc) \
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
      pgsql \
      pdo_sqlite \
      pdo_mysql \
      pdo_pgsql \
      phar \
      simplexml \
      soap \
      xml \
      zip && \
    docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
        --with-png-dir=/usr/include && \
    docker-php-ext-install -j$(nproc) gd && \
    apk del $buildDeps

RUN ln -s /usr/sbin/httpd /usr/sbin/apache2 && \
    ln -s /usr/lib/apache2/ /usr/lib/apache2/modules && \
    mkdir -p /usr/local/etc/php /tmp/sessions && \
    chown -R $USER:0 /usr/local/etc/php /tmp/sessions && \
    chmod -R 777 /usr/local/etc/php /tmp/sessions

# </template>
# <post>

# Standardize on UID $USER (alpine:3.4 does not have the shadow package)
RUN apk add shadow --no-cache --repository http://rsync.alpinelinux.org/alpine/latest-stable/community/ && \
    usermod -o -u $USER default && \
    apk del shadow

# Drop the root user and make the content of /opt/app-root owned by user default
RUN chown -R $USER:0 /opt/app-root && chmod -R ug+rwx /opt/app-root
USER $USER

ENTRYPOINT ["container-entrypoint"]

# </post>
