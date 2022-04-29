# sendmail

[![Build Status](https://github.com/smoeding/puppet-sendmail/actions/workflows/CI.yaml/badge.svg)](https://github.com/smoeding/puppet-sendmail/actions/workflows/CI.yaml)
[![Puppet Forge](http://img.shields.io/puppetforge/v/stm/sendmail.svg)](https://forge.puppetlabs.com/stm/sendmail)
[![License](https://img.shields.io/github/license/smoeding/puppet-sendmail.svg)](https://raw.githubusercontent.com/smoeding/puppet-sendmail/master/LICENSE)

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

Install and manage the Sendmail MTA.

## Module Description

Sendmail is a powerful mail transfer agent, and this modules provides an easier way to generate and manage the main Sendmail configuration files `/etc/mail/sendmail.mc` and `/etc/mail/submit.mc`. It also manages entries in various Sendmail database files (e.g. `/etc/mail/access` and `/etc/mail/mailertable`).

## Setup

### What sendmail affects

* The module installs the operating system package to run the Sendmail MTA and possibly some other packages (make, m4, ...) to support it.
* In a default installation almost all the managed files are in the `/etc/mail` directory. A notably exception is the `/etc/aliases` file.
* The module may generate a new `/etc/mail/sendmail.mc` which is the source for `/etc/mail/sendmail.cf`. This file is the main Sendmail configuration file and it affects how Sendmail operates.

> **WARNING**: Make sure to understand and test everything in these files before putting it in production. You alone are accountable for deploying a safe mailer configuration. If you do not know how to configure Sendmail without this module, then you should not assume you can do it with it.

### Setup Requirements

The sendmail module uses a custom Augeas lense so the Puppet configuration setting `pluginsync` must be enabled. It also requires the Puppetlabs modules `stdlib`, `concat`, `augeas_core` and `mailalias_core`.

### Beginning with Sendmail

Declare the Sendmail class to install and run Sendmail with the default parameters.

```puppet
class { 'sendmail': }
```

This installs the necessary packages and starts the Sendmail service. With this setup Sendmail will send messages to other hosts and also accept mail for the local host.

Sendmail has a lot of configuration knobs and a complete setup may need more than just a few parameters. So it is probably a good idea to encapsulate your Sendmail settings by using the roles and profiles pattern.

## Usage

The Sendmail module provides classes and defined types to individually manage many of the configuration parameters used in the `sendmail.mc` file. This offers the possibility to manage even complex and unusual configurations with Puppet. The main Sendmail class also has parameters to directly enable certain configuration items without the need to provide a complete user defined `sendmail.mc` configuration.

### I need a couple of macros and features in my Sendmail setting

Normally the configuration of Sendmail is done by adding `define` statements to the main `sendmail.mc` configuration file. The `m4` macro processor is used to convert the settings into a `sendmail.cf` file that Sendmail understands.

The same mechanism is used to add features like greylisting, virtual user setups or DNS blacklists. Sendmail uses the `feature` statement in the `sendmail.mc` configuration to enable the features.

With the Sendmail module these settings are defined by adding resources using the `sendmail::mc::define` or `sendmail::mc::feature` defined types.

```puppet
# Manage Sendmail and set a smart host and the maximum message size
class { 'sendmail':
  smart_host       => 'relay.example.com',
  max_message_size => '32MB',
}

# Set maximum number of daemon processes
sendmail::mc::define { 'confMAX_DAEMON_CHILDREN':
  expansion => '8',
}

# Include ratecontrol feature with parameters
sendmail::mc::feature { 'ratecontrol':
  args => [ 'nodelay', 'terminate', ],
}

# Enable access_db feature
sendmail::mc::feature { 'access_db': }

# Manage access_db entries in hiera
class { 'sendmail::access': }

# Manage aliases file using a template
class { 'sendmail::aliases':
  content => template('site/aliases.erb'),
}
```

See `REFERENCE.md` for the complete list of available types that can be used.

### Most hosts do not need to receive mail

Use the `sendmail::nullclient` class to create a setup where no mail can be received from the outside and all local mail is forwarded to a central mail hub. This configuration is appropriate for the majority of satellite hosts.

```puppet
class { 'sendmail::nullclient':
  mail_hub => '[192.168.1.1]',
}
```

### I already have a working config and like to keep it

Disable the internal management of the sendmail configuration files by setting the parameters `manage_sendmail_mc` or `manage_submit_mc` to `false`:

```puppet
class { 'sendmail':
  manage_sendmail_mc => false,
  manage_submit_mc   => false,
}
```

> **Note**: These settings also disable the automatic generation of the `sendmail.cf` and `submit.cf` files. You will have to do that yourself if you change one of the files.

### I am behind a firewall and need to forward outgoing mail to a relay host

Use the `smart_host` parameter to set the host where all outgoing mail should be forwarded to.

```puppet
class { 'sendmail':
  smart_host => 'relay.example.com',
}
```

### I have a host that should not receive any mail from the outside

You can use the `enable_ipv4_daemon` and `enable_ipv6_daemon` parameters to prevent Sendmail from listening on all available network interfaces. Use the `sendmail::mc::daemon_options` defined type to explicitly define the addresses to use.

```puppet
class { 'sendmail':
  enable_ipv4_daemon => false,
  enable_ipv6_daemon => false,
}

sendmail::mc::daemon_options { 'MTA-v4':
  addr   => '127.0.0.1',
  family => 'inet',
  port   => 'smtp',
}
```

### Transport layer encryption (TLS) is a must in my setup

The Sendmail class has a comprehensive set of TLS related parameters. The following configuration creates a simple TLS enabled setup. Remember to adjust the pathnames to your setup.

```puppet
class { 'sendmail':
  ca_cert_file     => '/etc/mail/tls/my-ca-cert.pem',
  server_cert_file => '/etc/mail/tls/server.pem',
  server_key_file  => '/etc/mail/tls/server.key',
  client_cert_file => '/etc/mail/tls/server.pem',
  client_key_file  => '/etc/mail/tls/server.key',
  cipher_list      => 'HIGH:!MD5:!eNULL',
}
```

> **Note**: The Sendmail module does not manage any X.509 certificates or keys.

### All my users are managed using LDAP

A complex configuration like this is supported by using the provided defined types as building blocks. The following example configuration reflects a setup that is actually in use.

```puppet
sendmail::mc::define { 'confLDAP_CLUSTER':
  expansion => 'example.net',
}

sendmail::mc::define { 'confLDAP_DEFAULT_SPEC':
  expansion => '-H ldapi:/// -w 3 -b dc=example,dc=net',
}

sendmail::mc::ldaproute_domain { 'example.net': }

$ldap_filter = '(&(objectClass=inetLocalMailRecipient)(mailLocalAddress=%0))'

sendmail::mc::feature { 'ldap_routing':
  args => [
    "ldap -1 -T<TMPF> -v mailHost -k ${ldap_filter}",
    "ldap -1 -T<TMPF> -v mailRoutingAddress -k ${ldap_filter}",
    'bounce',
    'preserve',
    'nodomain',
    'tempfail',
  ]
}

sendmail::mc::feature { 'virtusertable':
  args => "ldap -1 -T<TMPF> -v uid -k ${ldap_filter}",
}
```

## Reference

See the included `REFERENCE.md`.

## Limitations

The Sendmail module is currently developed and tested on:
* Debian 11 (Bullseye)

## Development

Sendmail is a powerful tool with many configuration options. The module includes configuration options I considered useful or needed for my own environment.

You may open Github issues for this module if you need additional configuration file options currently not available.

Feel free to send pull requests for new features.
