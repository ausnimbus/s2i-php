# AusNimbus Builder for PHP [![Build Status](https://travis-ci.org/ausnimbus/s2i-php.svg?branch=master)](https://travis-ci.org/ausnimbus/s2i-php) [![Docker Repository on Quay](https://quay.io/repository/ausnimbus/s2i-php/status "Docker Repository on Quay")](https://quay.io/repository/ausnimbus/s2i-php)

[![PHP](https://user-images.githubusercontent.com/2239920/27287522-52c8d548-5547-11e7-9830-d4e53152f535.jpg)](https://www.ausnimbus.com.au/)

The [AusNimbus](https://www.ausnimbus.com.au/) builder for PHP provides a fast, secure and reliable [PHP hosting](https://www.ausnimbus.com.au/languages/php-hosting/) environment.

This document describes the behaviour and environment configuration when running your PHP apps on AusNimbus.

## Table of Contents

- [Runtime Environments](#runtime-environments)
- [Web Process](#web-process)
- [Dependency Management](#dependency-management)
  - [require-dev](#require-dev)
  - [Prestissimo](#prestissimo)
- [Environment Configuration](#environment-configuration)
- [Advanced](#advanced)
  - [Build Customization](#build-customization)
    - [Configuring composer](#configuring-composer)
  - [Application Concurrency](#application-concurrency)
  - [Customizing Settings](#customizing-settings)
- [Extending](#extending)
  - [Build Stage (assemble)](#build-stage-assemble)
  - [Runtime Stage (run)](#runtime-stage-run)
  - [Persistent Environment Variables](#persistent-environment-variables)
- [Debug Mode](#debug-mode)
- [Troubleshooting](#troubleshooting)

## Runtime Environments

AusNimbus supports each of the major releases.

The currently supported versions are `5.6`, `7.0`, `7.1`

## Web Process

AusNimbus supports Apache 2.4 as the dedicated web server for your PHP applications. Apache interfaces with PHP-FPM using `mod_proxy_fcgi`.

AusNimbus handles SSL termination at the load balancer.

By default the root of your repository will be used as the document root. To use a sub-directory you may use the following environment variable:

NAME         | Description
-------------|-------------
DOCUMENTROOT | Path that defines the DocumentRoot for your application (ie. /public)

## Dependency Management

The builder uses [composer](http://getcomposer.org/) for installing dependencies. A valid `composer.json` file must be included for dependencies to be installed.

The following command is run to install your dependencies:

```
./composer.phar install --no-interaction --no-dev --optimize-autoloader
```

It is recommended to include a `composer.lock` file in your repository to ensure the state of your dependencies are consistent.

### require-dev

By default your application will be built and deployed in `production`. AusNimbus will not install development dependencies from the `require-dev` section of `composer.json` unless you explicitly set the [Debug Mode](#Debug Mode) as outlined below.

### Prestissimo

The [Prestissimo](https://github.com/hirak/prestissimo) parallel composer install plugin boasts significantly faster dependency install times and can be installed with the following environment variable:

NAME        | Description
------------|-------------
PRESTISSIMO | Set to TRUE will enable the [Prestissimo](https://github.com/hirak/prestissimo) parallel composer install plugin

## Environment Configuration

Both the PHP and OPCache sizes are automatically configured for you based on your app instance size.

Size     | Value
---------|-------------
Small    | php=128MB / opcache=64MB
Medium   | php=128MB / opcache=128MB
Large    | php=256MB / opcache=128MB
2xLarge  | php=368MB / opcache=128MB

Some of these values may not be ideal based on your application requirement. So you may optionally overwrite these values with the following environment variables:

Name                         | Description
-----------------------------|---------------------------------------------
PHP_MEMORY_LIMIT             | Set the PHP memory limit in MB
OPCACHE_MEMORY_CONSUMPTION   | Set the OPCache shared memory storage in MB

## Advanced

### Build Customization

#### Configuring composer

If you would like to use a custom composer mirror you may use the following environment variable:

NAME            | Description
----------------|-------------
COMPOSER_MIRROR | Define a custom composer registry mirror for downloading dependencies

### Application Concurrency

AusNimbus automatically calculates the number of child processes running your app based on the memory limits defined above.

The default configuration does not reserve any memory for the Apache web server and is optimized for applications that have auto scaling enabled.

This may be undesirable for non-scalable or memory intensive apps. If your application restarts frequently you may want to overwrite this configuration:

NAME            | Description
----------------|-------------
WEB_CONCURRENCY | Set the number of child processes running your app, by default this is automatically configured for you.

### Customizing Settings

Any `.ini` [files](http://docs.php.net/manual/en/configuration.file.per-user.php) placed into your repository will be loaded after the main `php.ini` file.

You may also configure OPCache with the following environment variables:

NAME                        | Description
----------------------------|-------------
OPCACHE_VALIDATE_TIMESTAMPS | Whether OPCache should check for changes in files. When set to 0, you must reset the OPcache manually or restart the webserver for changes to the filesystem to take effect. Default: 0
OPCACHE_REVALIDATE_FREQ     | How often OPCache should check for changes in files. Ignored if `OPCACHE_VALIDATE_TIMESTAMPS` is 0

## Extending

AusNimbus builders are split into two stages:

- Build
- Runtime

Both stages are completely extensible, allowing you to customize or completely overwrite each stage.

### Build Stage (assemble)

If you want to customize the build stage, you need to add the executable `.s2i/bin/assemble` file in your repository.

This file should contain the logic required to build and install any dependencies your application requires.

If you only want to extend the build stage, you may use this example:

```sh
#!/bin/bash

echo "Logic to include before"

# Run the default builder logic
. /usr/libexec/s2i/assemble

echo "Logic to include after"
```

### Runtime Stage (run)

You may customize or overwrite the entire runtime stage by including the executable file `.s2i/bin/run`

This file should contain the logic required to execute your application.

If you only want to extend the run stage, you may use this example:

```sh
#!/bin/bash

echo "Logic to include before"

# Run the default builder logic
. /usr/libexec/s2i/run
```

As the run script executes every time your application is deployed, scaled or restarted it's recommended to keep avoid including complex logic which may delay the start-up process of your application.

### Persistent Environment Variables

The recommend approach is to set your environment variables in the AusNimbus dashboard.

However it is possible to store environment variables in code using the `.s2i/environment` file.

The file expects a key=value format eg.

```
KEY=VALUE
FOO=BAR
```

## Debug Mode

The AusNimbus builder provides a convenient environment variable to help you debug your application.

NAME        | Description
------------|-------------
DEBUG       | Set to TRUE will enable common debug settings (ie. `DISPLAY_ERRORS=ON`, `ERROR_REPORTING=E_ALL & ~E_NOTICE`, `composer install --dev`, `OPCACHE_VALIDATE_TIMESTAMPS` etc.)

## Troubleshooting

### Why aren't my changes being picked up

The default value for `OPCACHE_VALIDATE_TIMESTAMPS=0` means any changes you make to files will not be read by the PHP process.

This is setting improves the response time of apps production as PHP files may be loaded entirely from memory.

If you require to edit files you should set the environment variable `OPCACHE_VALIDATE_TIMESTAMPS=1`
