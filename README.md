# PHP S2I Docker images

[![Build Status](https://travis-ci.org/ausnimbus/s2i-php.svg?branch=master)](https://travis-ci.org/ausnimbus/s2i-php)

This repository contains the source for building various versions of
the PHP application as a reproducible Docker image
[source-to-image](https://github.com/openshift/source-to-image)
to be run on [AusNimbus](https://www.ausnimbus.com.au/).

Images are built with PHP binaries from php.net
The resulting image can be run using [Docker](http://docker.io).

If you are interested in using SCL-based php binaries, use [s2i-scl-php](https://github.com/ausnimbus/s2i-scl-php)

## Versions

The versions currently supported are:

- 5.6
- 7.0
- 7.1
