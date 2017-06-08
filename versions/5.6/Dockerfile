#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "./hack/run update"
#
# DO NOT EDIT IT DIRECTLY.
#
FROM php:5.6-fpm
# <pre>

MAINTAINER AusNimbus <support@ausnimbus.com.au>

LABEL summary="Platform for running PHP 5.6 applications" \
      maintainer="AusNimbus <support@ausnimbus.com.au>" \
      io.k8s.description="Platform for running PHP 5.6 applications" \
      io.k8s.display-name="PHP 5.6"

ENV USER=999 \
    HOME=/opt/app-root/src

USER 0

RUN apt-get update && apt-get install -y \
      rsync nano vim && \
    ln -sf /bin/bash /bin/sh && \
    mkdir -p $HOME && \
    useradd -u 1001 -g 0 -d $HOME -s /sbin/nologin \
      -c "Default Application User" default && \
    chown -R 1001:0 /opt/app-root

# Copy common executable utilities.
COPY ./common/bin/ /usr/bin/

# Each container image can have 'contrib' a directory with extra files needed to
# run and build the application.
COPY ./contrib/ /opt/app-root

# </pre>
# <s2i>

RUN apt-get update && apt-get install -y git --no-install-recommends && rm -rf /var/lib/apt/lists/*

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
      gcc \
      autoconf \
      libcurl4-openssl-dev \
      libedit-dev \
      libssl-dev" && \
    phpDeps=" \
      gettext \
      libicu-dev \
      libxml2-dev \
      zlib1g-dev \
      libpq5 \
      libpq-dev \
      libmysqlclient18 \
      libmysqlclient-dev \
      libmemcached-dev \
      libsqlite3-dev \
      libmcrypt-dev \
      libfreetype6 \
      libfreetype6-dev \
      libjpeg62-turbo \
      libjpeg62-turbo-dev \
      libpng12-dev \
      libjpeg-dev \
      libpng++-dev \
      libgd-dev \
      libltdl-dev \
      unzip" && \
    apt-get update && apt-get install -yq apache2 $phpDeps $buildDeps --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
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
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps

RUN ln -s /etc/mime.types /etc/apache2/mime.types && \
    mkdir -p /usr/local/etc/php && \
    chown -R $USER:0 /usr/local/etc/php && \
    chmod -R 777 /usr/local/etc/php

# </template>
# <post>

# Standardize on UID $USER
RUN usermod -o -u $USER default

# Drop the root user and make the content of /opt/app-root owned by user default
RUN chown -R $USER:0 /opt/app-root && chmod -R ug+rwx /opt/app-root
USER $USER

ENTRYPOINT ["container-entrypoint"]

# </post>
