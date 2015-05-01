# sendmail

[![Build Status](https://travis-ci.org/smoeding/puppet-sendmail.svg?branch=master)](https://travis-ci.org/smoeding/puppet-sendmail)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with sendmail](#setup)
	* [What sendmail affects](#what-sendmail-affects)
	* [Setup requirements](#setup-requirements)
	* [Beginning with sendmail](#beginning-with-sendmail)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Install and manage the sendmail MTA.

## Module Description

Sendmail is a powerful mail transfer agent, and this modules provides an easy way to manage the main Sendmail configuration files `/etc/mail/sendmail.mc` and `/etc/mail/submit.mc`. It also manages entries in various Sendmail database files (e.g. `/etc/mail/access` and `/etc/mail/mailertable`).

## Setup

### What sendmail affects

* The module installs the operating system package to run the Sendmail MTA and possibly some other modules to support it (make, m4, ...)
* In a default installation almost all the manged files are in the `/etc/mail` directory. A notably exception is the `/etc/aliases` file.
* The module may generate a new `/etc/mail/sendmail.mc` which is the source for `/etc/mail/sendmail.cf`. This file is the main Sendmail configuration file and it affects where Sendmail will send mails to and accept mail from. **WARNING**: Make sure to understand and test everything in these files before putting it in production.

### Setup Requirements

The sendmail module brings additional Augeas lenses so `pluginsync` must be enabled. It also requires the Puppetlabs modules `stdlib` and `concat`.

### Beginning with sendmail

To install Sendmail with the default parameters

```
class { 'sendmail': }
```

Currently this only installs the package and starts the service. No configuration file is changed by this class.

See the next section for a detailed description of the available configuration knobs.

## Usage

TBD...

## Reference

### Classes

#### Public Classes

#### Private Classes

### Defined Types

### Templates

### Augeas lenses

## Limitations

The sendmail package is developed and tested on Debian 7 (Wheezy). More supported operating systems are planned in future releases.

## Development

Sendmail is a powerful tool with many configuration options. The module includes configuration options I considered useful or needed for my own environment.

You may open Github issues for this module if you need additional configuration file options currently not available.

Feel free to send pull requests for new features.
