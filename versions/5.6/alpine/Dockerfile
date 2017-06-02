#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "./hack/run update"
#
# DO NOT EDIT IT DIRECTLY.
#
FROM php:5.6-alpine
# <pre>

MAINTAINER AusNimbus <support@ausnimbus.com.au>

LABEL summary="Platform for running PHP 5.6 applications" \
      maintainer="AusNimbus <support@ausnimbus.com.au>" \
      io.k8s.description="Platform for running PHP 5.6 applications" \
      io.k8s.display-name="PHP 5.6"

ENV USER=100 \
    HOME=/opt/app-root/src

USER 0

RUN apk --no-cache add bash rsync && \
    mkdir -p ${HOME}/.pki/nssdb && \
    chown -R 1001:0 ${HOME}/.pki && \
    adduser -S -u 1001 -G root -h ${HOME} -s /sbin/nologin \
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
      apache2-dev \
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
    apk add --no-cache apache2 $phpDeps $buildDeps && \
    echo "Building PHP, this will take some time.. (output suppressed)" && \
    (docker-php-source extract && \
      cd /usr/src/php && \
      ./configure \
        --build=x86_64-linux-musl \
        --with-config-file-path=/usr/local/etc/php \
        --with-config-file-scan-dir=/usr/local/etc/php/conf.d \
        --disable-cgi \
        --enable-ftp \
        --enable-mbstring \
        --enable-mysqlnd \
        --with-curl \
        --with-libedit \
        --with-openssl \
        --with-zlib \
        --with-pcre-regex=/usr \
        build_alias=x86_64-linux-musl \
        CFLAGS="-fstack-protector-strong -fpic -fpie -O2" \
        LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie" \
        CPPFLAGS="-fstack-protector-strong -fpic -fpie -O2" \
        --with-apxs2 \
        --enable-maintainer-zts && \
      make -j "$(nproc)" && \
      make install && \
      { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; } && \
      make clean && \
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
    docker-php-source delete) > /dev/null 2>&1 && \
    apk del $buildDeps

RUN sed -i -f /opt/app-root/etc/httpdconf.sed /etc/apache2/httpd.conf && \
    sed -i -f /opt/app-root/etc/httpdconf.sed /etc/apache2/ports.conf && \
    echo "IncludeOptional /opt/app-root/etc/conf.d/*.conf" >> /etc/apache2/httpd.conf && \
    rm -f /etc/apache2/sites-enabled/* && \
    rm -f /etc/apache2/conf-enabled/* && \
    rm -f /etc/apache2/mods-enabled/mpm_event* && \
    mkdir -p /run/apache2 /lock/apache2 /tmp/sessions && \
    chown -R $USER:0 /run/apache2 /lock/apache2 /tmp/sessions && \
    chmod -R ug+rwx /run/apache2 /lock/apache2 /usr/local/etc/php /tmp/sessions

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
