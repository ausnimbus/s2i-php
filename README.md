# PHP S2I Builder

[![Build Status](https://travis-ci.org/ausnimbus/s2i-php.svg?branch=master)](https://travis-ci.org/ausnimbus/s2i-php)
[![Docker Repository on Quay](https://quay.io/repository/ausnimbus/s2i-php/status "Docker Repository on Quay")](https://quay.io/repository/ausnimbus/s2i-php)

This repository contains the source for the [source-to-image](https://github.com/openshift/source-to-image)
builders used to deploy [PHP applications](https://www.ausnimbus.com.au/languages/php/)
on [AusNimbus](https://www.ausnimbus.com.au/).

The builders are built using PHP binaries from php.net

If you are interested in using SCL-based PHP binaries, use [s2i-php-scl](https://github.com/ausnimbus/s2i-php-scl)

## Versions

The versions currently supported are:

- 5.6
- 7.0
- 7.1
