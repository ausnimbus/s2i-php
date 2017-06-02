#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "./hack/run update"
#
# DO NOT EDIT IT DIRECTLY.
#
FROM php:7.1
# <pre>

MAINTAINER AusNimbus <support@ausnimbus.com.au>

LABEL summary="Platform for running PHP 7.1 applications" \
      maintainer="AusNimbus <support@ausnimbus.com.au>" \
      io.k8s.description="Platform for running PHP 7.1 applications" \
      io.k8s.display-name="PHP 7.1"

ENV USER=999 \
    HOME=/opt/app-root/src

USER 0

RUN apt-get update && apt-get install -y \
      rsync nano vim && \
    mkdir -p $HOME && \
    useradd -u 1001 -g 0 -d ${HOME} -s /sbin/nologin \
      -c "Default Application User" default && \
    chown -R 1001:0 /opt/app-root

# Copy common executable utilities.
COPY ./common/bin/ /usr/bin/

# Each container image can have 'contrib' a directory with extra files needed to
# run and build the application.
COPY ./contrib/ /opt/app-root

# </pre>
# <s2i>

RUN apt-get install -y git

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
    apt-get update && apt-get install -y apache2 $phpDeps $buildDeps --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-source extract && \
      cd /usr/src/php && \
      ./configure \
        --build=x86_64-linux-gnu \
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
        --with-libdir=lib/x86_64-linux-gnu \
        build_alias=x86_64-linux-gnu \
        CFLAGS="-fstack-protector-strong -fpic -fpie -O2" \
        LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie" \
        CPPFLAGS="-fstack-protector-strong -fpic -fpie -O2" \
        --with-apxs2 && \
      make -j "$(nproc)" && \
      make install && \
      { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; } && \
      make clean && \
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
    docker-php-ext-install gd && \
    docker-php-source delete && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps

RUN sed -i -f /opt/app-root/etc/httpdconf.sed /etc/apache2/apache2.conf && \
    sed -i -f /opt/app-root/etc/httpdconf.sed /etc/apache2/ports.conf && \
    echo "IncludeOptional /opt/app-root/etc/conf.d/*.conf" >> /etc/apache2/apache2.conf && \
    rm -f /etc/apache2/sites-enabled/* && \
    rm -f /etc/apache2/conf-enabled/* && \
    rm -f /etc/apache2/mods-enabled/mpm_event* && \
    mkdir -p /run/apache2 /lock/apache2 /tmp/sessions && \
    chown -R 999:0 /run/apache2 /lock/apache2 /usr/local/etc/php /tmp/sessions && \
    chmod -R ug+rwx /run/apache2 /lock/apache2 /usr/local/etc/php /tmp/sessions

# </template>
# <post>

# Standardize on UID $USER
RUN usermod -o -u $USER default

# Drop the root user and make the content of /opt/app-root owned by user default
RUN chown -R $USER:0 /opt/app-root && chmod -R ug+rwx /opt/app-root
USER $USER

ENTRYPOINT ["container-entrypoint"]

# </post>
