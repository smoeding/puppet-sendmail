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

Install and manage the Sendmail MTA.

## Module Description

Sendmail is a powerful mail transfer agent, and this modules provides an easy way to manage the main Sendmail configuration files `/etc/mail/sendmail.mc` and `/etc/mail/submit.mc`. It also manages entries in various Sendmail database files (e.g. `/etc/mail/access` and `/etc/mail/mailertable`).

## Setup

### What sendmail affects

* The module installs the operating system package to run the Sendmail MTA and possibly some other modules to support it (make, m4, ...)
* In a default installation almost all the managed files are in the `/etc/mail` directory. A notably exception is the `/etc/aliases` file.
* The module may generate a new `/etc/mail/sendmail.mc` which is the source for `/etc/mail/sendmail.cf`. This file is the main Sendmail configuration file and it affects how Sendmail operates.

**WARNING**: Make sure to understand and test everything in these files before putting it in production. You are responsible to deploy a safe mailer configuration.

### Setup Requirements

The sendmail module uses a custom Augeas lense so `pluginsync` must be enabled. It also requires the Puppetlabs modules `stdlib` and `concat`.

### Beginning with Sendmail

Declare the Sendmail class to install and run Sendmail with the default parameters.

```puppet
class { '::sendmail': }
```

This installs the necessary packages and starts the Sendmail service. With this setup Sendmail will send messages to other hosts and also accept mail for the local host.

Sendmail has a lot of configuration knobs and a complete setup may need more than just a few parameters. So it is probably a good idea to encapsulate your Sendmail settings by using the roles and profiles pattern.

See the next sections for a detailed description of the available configuration options.

## Usage

The Sendmail module provides classes and defined types to individually manage many of the configuration parameters used in the `sendmail.mc` file. This offers the possibility to manage even complex and unusual configurations with Puppet. The main Sendmail class also has parameters to directly enable certain configuration items without the need to provide a complete user defined `sendmail.mc` configuration.

### I have a working config and like to keep it

Disable the internal management of the sendmail configuration files by setting the parameters `manage_sendmail_mc` or `manage_submit_mc` to `false`:

```puppet
class { '::sendmail':
  manage_sendmail_mc => false,
  manage_submit_mc   => false,
}
```

**Note**: These settings also disable the automatic generation of the `sendmail.cf` and `submit.cf` files. You will have to do that yourself if you change one of the files.

### I am behind a firewall and need to forward outgoing mail to a relay host

Use the `smart_host` parameter to set the host where all outgoing mail should be forwarded to.

```puppet
class { '::sendmail':
  smart_host => 'relay.example.com',
}
```

### I want to define additional macros in my configuration

Use the parameter `defines` to add a hash of additional settings to the `sendmail.mc` configuration file:

```puppet
class { '::sendmail':
  defines => {},
}
```

### I like to add more features to my configuration

The parameter `features` takes a hash with additional features to be added:

```puppet
class { '::sendmail':
  features => { 'access_db' },
}
```

### I have a host that should not receive any mail

You can use the `enable_ipv4_daemon` and `enable_ipv6_daemon` parameters to prevent Sendmail from listening on all available network interfaces. Use the `sendmail::mc::daemon_options` type to explicitly define the address to use.

```puppet
class { '::sendmail':
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
class { '::sendmail':
  ca_cert_file     => '/etc/mail/tls/CA.pem',
  server_cert_file => '/etc/mail/tls/server.pem',
  server_key_file  => '/etc/mail/tls/server.key',
  client_cert_file => '/etc/mail/tls/client.pem',
  client_key_file  => '/etc/mail/tls/client.key',
  dh_params        => '2048',
}
```

**Note**: The Sendmail module does not manage any certificates or keys.

## Reference

- [**Public Classes**](#public-classes)
  - [Class: sendmail](#class-sendmail)
  - [Class: sendmail::access](#class-sendmail-access)
  - [Class: sendmail::aliases](#class-sendmail-aliases)
  - [Class: sendmail::authinfo](#class-sendmail-authinfo)
  - [Class: sendmail::domaintable](#class-sendmail-domaintable)
  - [Class: sendmail::genericstable](#class-sendmail-genericstable)
  - [Class: sendmail::local_host_names](#class-sendmail-local_host_names)
  - [Class: sendmail::mailertable](#class-sendmail-mailertable)
  - [Class: sendmail::mc](#class-sendmail-mc)
  - [Class: sendmail::parameterfile](#class-sendmail-parameterfile)
  - [Class: sendmail::relay_domains](#class-sendmail-relay_domains)
  - [Class: sendmail::submit](#class-sendmail-submit)
  - [Class: sendmail::trusted_users](#class-sendmail-trusted_users)
  - [Class: sendmail::userdb](#class-sendmail-userdb)
  - [Class: sendmail::virtusertable](#class-sendmail-virtusertable)
- [**Private Classes**](#private-classes)
  - [Class: sendmail::aliases::newaliases](#class-sendmail-aliases-newaliases)
  - [Class: sendmail::makeall](#class-sendmail-makeall)
  - [Class: sendmail::package](#class-sendmail-package)
  - [Class: sendmail::params](#class-sendmail-params)
  - [Class: sendmail::service](#class-sendmail-service)
  - [Classes: sendmail::*::file](#class-sendmail-*-file)
  - [Classes: sendmail::mc::*_section](#class-sendmail-mc-*_section)
- [**Public Defined Types**](#public-defined-types)
  - [Define: sendmail::access::entry](#define-sendmail-access-entry)
  - [Define: sendmail::aliases::entry](#define-sendmail-aliases-entry)
  - [Define: sendmail::authinfo::entry](#define-sendmail-authinfo-entry)
  - [Define: sendmail::domaintable::entry](#define-sendmail-domaintable-entry)
  - [Define: sendmail::genericstable::entry](#define-sendmail-genericstable-entry)
  - [Define: sendmail::local_host_names::entry](#define-sendmail-local_host_names-entry)
  - [Define: sendmail::mailertable::entry](#define-sendmail-mailertable-entry)
  - [Define: sendmail::relay_domains::entry](#define-sendmail-relay_domains-entry)
  - [Define: sendmail::trusted_users::entry](#define-sendmail-trusted_users-entry)
  - [Define: sendmail::userdb::entry](#define-sendmail-userdb-entry)
  - [Define: sendmail::virtusertable::entry](#define-sendmail-virtusertable-entry)
  - [Define: sendmail::mc::daemon_options](#define-sendmail-mc-daemon_options)
  - [Define: sendmail::mc::define](#define-sendmail-mc-define)
  - [Define: sendmail::mc::domain](#define-sendmail-mc-domain)
  - [Define: sendmail::mc::enhdnsbl](#define-sendmail-mc-enhdnsbl)
  - [Define: sendmail::mc::feature](#define-sendmail-mc-feature)
  - [Define: sendmail::mc::local_config](#define-sendmail-mc-local_config)
  - [Define: sendmail::mc::mailer](#define-sendmail-mc-mailer)
  - [Define: sendmail::mc::modify_mailer_flags](#define-sendmail-mc-modify_mailer_flags)
  - [Define: sendmail::mc::ostype](#define-sendmail-mc-ostype)
  - [Define: sendmail::mc::starttls](#define-sendmail-mc-starttls)
  - [Define: sendmail::mc::trust_auth_mech](#define-sendmail-mc-trust_auth_mech)
  - [Define: sendmail::mc::versionid](#define-sendmail-mc-versionid)
- [**Augeas Lenses**](#augeas-lenses)
  - [Augeas Lens: sendmail_map](#lens: sendmail_map)
- [**Templates**](#templates)

### Public Classes

#### Class: `sendmail`

Performs the basic setup and installation of Sendmail on the system.

**Parameters for the `sendmail` class:**

##### `smart_host`

Servers that are behind a firewall may not be able to deliver mail directly to the outside world. In this case the host may need to forward the mail to the gateway machine defined by this parameter. All nonlocal mail is forwarded to this gateway. Default value: undef.

##### `log_level`

The loglevel for the sendmail process. Valid options: a numeric value. Default value: undef.

##### `dont_probe_interfaces`

Sendmail normally probes all network interfaces to get all hostnames that the server may have. These hostnames are then considered local. This option can be used to prevent the reverse lookup of the network addresses. If this option is set to `localhost` then all network interfaces except for the loopback interface is probed. Valid options: the strings `true`, `false` or `localhost`. Default value: undef.

##### `enable_ipv4_daemon`

Should the host accept mail on all IPv4 network adresses. Valid options: `true` or `false`. Default value: `true`.

##### `enable_ipv6_daemon`

Should the host accept mail on all IPv6 network adresses. Valid options: `true` or `false`. Default value: `true`.

##### `enable_aliases`

Automaticall manage the aliases file. This parameter only manages the file and not the content. Valid options: `true` or `false`. Default value: `true`.

##### `aliases`

A hash that will be used to create `sendmail::aliases::entry` resources. Default value: {}

##### `enable_access_db`

Automatically manage the access database file. This parameter only manages the file and not the content. Valid options: `true` or `false`. Default value: `true`.

##### `mailers`

An array of mailers to add to the configuration. Default value: `[ 'smtp', 'local' ]`

##### `local_host_names`

An array of hostnames that Sendmail recognizes for local delivery. Default values: `[ $::fqdn ]`

##### `relay_domains`

An array of domains that Sendmail accepts as relay target. This setting is required for secondary MX setups. Default value: `[]`

##### `trusted_users`

An array of user names that will be written into the trusted users file. Leading or trailing whitespace is ignored. Empty entries are also ignored. Default value: `[]`

##### `trust_auth_mech`

The value of trusted authentication mechanisms to set. If this is a string it is used as-is. For an array the value will be concatenated into a string. Default value: undef

##### `ca_cert_file`

The filename of the SSL CA certificate.

##### `ca_cert_path`

The directory where SSL CA certificates are kept.

##### `server_cert_file`

The filename of the SSL server certificate for inbound connections.

##### `server_key_file`

The filename of the SSL server key for inbound connections.

##### `client_cert_file`

The filename of the SSL client certificate for outbound connections.

##### `client_key_file`

The filename of the SSL client key for outbound connections.

##### `crl_file`

The filename with a list of revoked certificates.

##### `dh_params`

The DH parameters used for encryption. This can be one of the numbers `512`, `1024`, `2048` or a filename with pregenerated parameters.

##### `cipher_list`

Set the available ciphers for encrypted conections.

##### `server_ssl_options`

Configure the SSL connection flags for inbound connections.

##### `client_ssl_options`

Configure the SSL connection flags for outbound connections.

##### `cf_version`

The configuration version string for Sendmail. This string will be appended to the Sendmail version in the HELO message. If unset, no configuration version will be used. Default value: undef.

##### `version_id`

The version id string included in the `sendmail.mc` file. This has no practical meaning other than having a user defined identifier in the file. Default value: undef.

##### `msp_host`

The host where the message submission program should deliver to. This can be a hostname or IP address. To prevent MX lookups for the host, put it in square brackets (e.g., `[hostname]`). Delivery to the local host would therefore use either `[127.0.0.1]` for IPv4 or `[IPv6:::1]` for IPv6.

##### `msp_port`

The port used for the message submission program. Can be a port number (e.g., `25`) or the literal `MSA` for delivery to the message submission agent on port 587.

##### `auxiliary_packages`

Additional packages that will be installed by the Sendmail module. Valid options: array of strings. Default value: varies by operating system.

##### `package_ensure`

Configure whether the Sendmail package should be installed, and what version. Valid options: `present`, `latest`, or a specific version number. Default value: `present`

##### `package_manage`

Configure whether Puppet should manage the Sendmail package(s). Valid options: `true` or `false`. Default value: `true`.

##### `service_name`

The service name to use on this operating system.

##### `service_enable`

Configure whether the Sendmail MTA should be enabled at boot. Valid options: `true` or `false`. Default value: `true`.

##### `service_manage`

Configure whether Puppet should manage the Sendmail service. Valid options: `true` or `false`. Default value: `true`.

##### `service_ensure`

Configure whether the Sendmail service should be running. Valid options: `running` or `stopped`. Default value: `running`.

##### `service_hasstatus`

Define whether the service type can rely on a working init script status. Valid options: `true` or `false`. Default value depends on the operating system and release.

#### Class: `sendmail::access`
#### Class: `sendmail::aliases`
#### Class: `sendmail::authinfo`
#### Class: `sendmail::domaintable`
#### Class: `sendmail::genericstable`
#### Class: `sendmail::local_host_names`
#### Class: `sendmail::mailertable`
#### Class: `sendmail::mc`
#### Class: `sendmail::parameterfile`
#### Class: `sendmail::relay_domains`
#### Class: `sendmail::submit`
#### Class: `sendmail::trusted_users`
#### Class: `sendmail::userdb`
#### Class: `sendmail::virtusertable`

### Private Classes

#### Class: `sendmail::aliases::newaliases`

Triggers the rebuild of the alias database after modifying an entry in the aliases file.

#### Class: `sendmail::makeall`

Triggers the rebuild of various Sendmail files. This includes conversion of `sendmail.mc` into `sendmail.cf` and generation of the Sendmail database map files.

#### Class: `sendmail::package`

Installs the necessary Sendmail packages.

#### Class: `sendmail::params`

The parameter class that contains operating specific values.

#### Class: `sendmail::service`

Manages the Sendmail service.

#### Classes: `sendmail::*::file`

These classes manage the various Sendmail database files and ensure correct owner, group and permissions.

#### Classes: `sendmail::mc::*_section`

These classes are included by some of the `sendmail::mc::*` defined types to create a suitable section header in the generated `sendmail.mc` file. The sole purpose is to improve the readability of the file.

### Public Defined Types

#### Define: `sendmail::access::entry`

Create entries in the Sendmail access db file. The type has an internal dependency to rebuild the database file.

**Parameters for the `sendmail::access::entry` type:**

##### `value`

The value for the given key. For the access map this is typically something like `OK`, `REJECT` or `DISCARD`.

##### `key`

The key used by Sendmail for the lookup. This could for example be a domain name. Default is the resource title.

##### `ensure`

Used to create or remove the access db entry. Default: `present`

```puppet
sendmail::access::entry { 'example.com':
  value => 'RELAY',
}
```

#### Define: `sendmail::aliases::entry`
#### Define: `sendmail::authinfo::entry`
#### Define: `sendmail::domaintable::entry`
#### Define: `sendmail::genericstable::entry`
#### Define: `sendmail::local_host_names::entry`
#### Define: `sendmail::mailertable::entry`
#### Define: `sendmail::relay_domains::entry`
#### Define: `sendmail::trusted_users::entry`
#### Define: `sendmail::userdb::entry`
#### Define: `sendmail::virtusertable::entry`
#### Define: `sendmail::mc::daemon_options`
#### Define: `sendmail::mc::define`
#### Define: `sendmail::mc::domain`
#### Define: `sendmail::mc::enhdnsbl`
#### Define: `sendmail::mc::feature`
#### Define: `sendmail::mc::local_config`
#### Define: `sendmail::mc::mailer`
#### Define: `sendmail::mc::modify_mailer_flags`
#### Define: `sendmail::mc::ostype`
#### Define: `sendmail::mc::starttls`
#### Define: `sendmail::mc::trust_auth_mech`
#### Define: `sendmail::mc::versionid`

### Augeas Lenses

#### Augeas Lens: `sendmail_map`

The Sendmail module contains the Augeas lens `sendmail_map`. This lens has been built to easily manage entries in various Sendmail files (e.g. `mailertable`, `access_db`, ...). The lens is used by the provided module classes and so there should not be any need to call this lens directly.

### Templates

The Sendmail module uses templates to build the `sendmail.mc` and `submit.mc` files. These are not meant for user configuration.

## Limitations

The Sendmail module is currently developed and tested on:
* Debian 7 (Wheezy)
* Debian 8 (Jessie)

More supported operating systems are planned in future releases.

## Development

Sendmail is a powerful tool with many configuration options. The module includes configuration options I considered useful or needed for my own environment.

You may open Github issues for this module if you need additional configuration file options currently not available.

Feel free to send pull requests for new features.
