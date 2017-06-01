# PHP S2I Builder

[![Build Status](https://travis-ci.org/ausnimbus/s2i-php.svg?branch=master)](https://travis-ci.org/ausnimbus/s2i-php)
[![Docker Repository on Quay](https://quay.io/repository/ausnimbus/s2i-php/status "Docker Repository on Quay")](https://quay.io/repository/ausnimbus/s2i-php)

This repository contains the source for the [source-to-image](https://github.com/openshift/source-to-image)
builders used to deploy [PHP applications](https://www.ausnimbus.com.au/languages/php/)
on [AusNimbus](https://www.ausnimbus.com.au/).

The builders are built using PHP binaries from php.net

If you are interested in using SCL-based PHP binaries, use [s2i-php-scl](https://github.com/ausnimbus/s2i-php-scl)

## Environment Variables

The following environment variables are made available:

* **DOCUMENTROOT**
  * Path that defines the DocumentRoot for your application (ie. /public)
  * Default: /
* **PRESTISSIMO**
  * Set to TRUE to enable the [Prestissimo](https://github.com/hirak/prestissimo) parallel composer install plugin

The following environment variables set their equivalent property value in the php.ini file:
* **ERROR_REPORTING**
  * Informs PHP of which errors, warnings and notices you would like it to take action for
  * Default: E_ALL & ~E_NOTICE
* **DISPLAY_ERRORS**
  * Controls whether or not and where PHP will output errors, notices and warnings
  * Default: ON
* **DISPLAY_STARTUP_ERRORS**
  * Cause display errors which occur during PHP's startup sequence to be handled separately from display errors
  * Default: OFF
* **TRACK_ERRORS**
  * Store the last error/warning message in $php_errormsg (boolean)
  * Default: OFF
* **HTML_ERRORS**
  * Link errors to documentation related to the error
  * Default: ON
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
  * Default: 128
* **OPCACHE_REVALIDATE_FREQ**
  * How often to check script timestamps for updates, in seconds. 0 will result in OPcache checking for updates on every request.
  * Default: 2

You can also override the entire directory used to load the PHP configuration by setting:
* **PHPRC**
  * Sets the path to the php.ini file
* **PHP_INI_SCAN_DIR**
  * Path to scan for additional ini configuration files

You can override the Apache [MPM prefork](https://httpd.apache.org/docs/2.4/mod/mpm_common.html)
settings to increase the performance of your PHP application. Sane default settings are set,
however you can override this at any time by specifying the values
yourself:

* **HTTPD_MAX_REQUEST_WORKERS**
  * The [MaxRequestWorkers](https://httpd.apache.org/docs/2.4/mod/mpm_common.html#maxrequestworkers)
    directive sets the limit on the number of simultaneous requests that will be served.
  * Default: `PHPFPMD_MAX_CHILDREN / 2`
* **HTTPD_START_SERVERS**
  * The [StartServers](https://httpd.apache.org/docs/2.4/mod/mpm_common.html#startservers)
    directive sets the number of child server processes created on startup.
  * Default: HTTPD_MAX_REQUEST_WORKERS/4

You can also override the PHP-fpm settings
* **PHPFPMD_MAX_CHILDREN**
  * The PHPFPMD_MAX_CHILDREN directive sets the limit of the number of simultaneous PHP-fpm
    workers that should run.
    * Default: `TOTAL_MEMORY / 128MB`. The 128MB is the default php max memory limit

You can use a custom composer repository mirror URL to download packages instead of the default 'packagist.org':

* **COMPOSER_MIRROR**
  * Adds a custom composer repository mirror URL to composer configuration. Note: This only affects packages listed in composer.json.

## Versions

The versions currently supported are:

- 5.6
- 7.0
- 7.1
