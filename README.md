# AusNimbus Builder for PHP

[![Build Status](https://travis-ci.org/ausnimbus/s2i-php.svg?branch=master)](https://travis-ci.org/ausnimbus/s2i-php)
[![Docker Repository on Quay](https://quay.io/repository/ausnimbus/s2i-php/status "Docker Repository on Quay")](https://quay.io/repository/ausnimbus/s2i-php)

[AusNimbus](https://www.ausnimbus.com.au/) builder for PHP provides a fast, secure and reliable [PHP hosting](https://www.ausnimbus.com.au/languages/php-hosting/) environment.

## Environment Variables

The following environment variables are made available:

* **DOCUMENTROOT**
  * Path that defines the DocumentRoot for your application (ie. /public)
  * Default: /
* **WEB_CONCURRENCY**
  * Set the number of child processes running your app, by default this is automatically
    configured for you
  * Default: `$((MEMORY_LIMIT/PHP_MEMORY_LIMIT))`
* **DEBUG**
  * Set to TRUE to enable common debug settings (ie. `DISPLAY_ERRORS=ON`, `composer install --dev`, `OPCACHE_VALIDATE_TIMESTAMPS` etc.)
  * Default: FALSE
* **PRESTISSIMO**
  * Set to TRUE to enable the [Prestissimo](https://github.com/hirak/prestissimo) parallel composer install plugin
  * Default: FALSE

The following environment variables set their equivalent property value in the php.ini file:
* **PHP_MEMORY_LIMIT**
  * Set the default PHP memory limit in MB
  * Default: 128
* **ERROR_REPORTING**
  * Informs PHP of which errors, warnings and notices you would like it to take action for
  * Default: E_ALL & ~E_NOTICE
* **DISPLAY_ERRORS**
  * Controls whether or not and where PHP will output errors, notices and warnings
  * Default: OFF
* **DISPLAY_STARTUP_ERRORS**
  * Cause display errors which occur during PHP's startup sequence to be handled separately from display errors
  * Default: OFF
* **TRACK_ERRORS**
  * Store the last error/warning message in $php_errormsg (boolean)
  * Default: OFF
* **HTML_ERRORS**
  * Link errors to documentation related to the error
  * Default: OFF
* **INCLUDE_PATH**
  * Path for PHP source files
  * Default: .:/opt/app-root/src
* **SESSION_PATH**
  * Location for session data files
  * Default: /tmp/sessions
* **SHORT_OPEN_TAG**
  * Determines whether or not PHP will recognize code between <? and ?> tags
  * Default: OFF

The following environment variables set their equivalent property value in the opcache.ini file:
* **OPCACHE_MEMORY_CONSUMPTION**
  * The OPcache shared memory storage size in megabytes
  * Default: `$memory_limit/4MB`
* **OPCACHE_VALIDATE_TIMESTAMPS**
  * Whether OPCache should check for changes in files. When set to 0, you must reset the OPcache
    manually or restart the webserver for changes to the filesystem to take effect.
  * Default: 0
* **OPCACHE_REVALIDATE_FREQ**
  * How often to check script timestamps for updates, in seconds.
    0 will result in OPcache checking for updates on every request.
    Ignored if OPCACHE_VALIDATE_TIMESTAMPS is 0
  * Default: 2

You can use a custom composer repository mirror URL to download packages instead of the default 'packagist.org':

* **COMPOSER_MIRROR**
  * Adds a custom composer repository mirror URL to composer configuration. Note: This only affects packages listed in composer.json.

## Versions

The versions currently supported are:

- 5.6
- 7.0
- 7.1

## Variants

Two different variants are made available:

- Default
- Alpine
