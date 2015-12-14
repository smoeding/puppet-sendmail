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
* The module may generate a new `/etc/mail/sendmail.mc` which is the source for `/etc/mail/sendmail.cf`. This file is the main Sendmail configuration file and it affects how Sendmail operates. **WARNING**: Make sure to understand and test everything in these files before putting it in production. You are responsible to deploy a safe mailer configuration.

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

Note that these settings also disable the automatic generation of the `sendmail.cf` and `submit.cf` files.

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

::sendmail::mc::daemon_options { 'MTA-v4':
  addr   => '127.0.0.1',
  family => 'inet',
  port   => 'smtp',
}
```

### Transport layer encryption (TLS) is a must in my setup

## Reference

- [**Public Classes**](#public-classes)
	- [Class: sendmail](#class-sendmail)
	- [Class: sendmail::access](#sendmail-access)
	- [Class: sendmail::aliases](#sendmail-aliases)
	- [Class: sendmail::authinfo](#sendmail-authinfo)
	- [Class: sendmail::domaintable](#sendmail-domaintable)
	- [Class: sendmail::genericstable](#sendmail-genericstable)
	- [Class: sendmail::local_host_names](#sendmail-local_host_names)
	- [Class: sendmail::mailertable](#sendmail-mailertable)
	- [Class: sendmail::mc](#sendmail-mc)
	- [Class: sendmail::parameterfile](#sendmail-parameterfile)
	- [Class: sendmail::relay_domains](#sendmail-relay_domains)
	- [Class: sendmail::submit](#sendmail-submit)
	- [Class: sendmail::trusted_users](#sendmail-trusted_users)
	- [Class: sendmail::userdb](#sendmail-userdb)
	- [Class: sendmail::virtusertable](#sendmail-virtusertable)
- [**Private Classes**](#private-classes)
	- [Class: sendmail::access::file](#sendmail-access-file)
	- [Class: sendmail::aliases::file](#sendmail-aliases-file)
	- [Class: sendmail::aliases::newaliases](#sendmail-aliases-newaliases)
	- [Class: sendmail::authinfo::file](#sendmail-authinfo-file)
	- [Class: sendmail::domaintable::file](#sendmail-domaintable-file)
	- [Class: sendmail::genericstable::file](#sendmail-genericstable-file)
	- [Class: sendmail::local_host_names::file](#sendmail-local_host_names-file)
	- [Class: sendmail::mailertable::file](#sendmail-mailertable-file)
	- [Class: sendmail::makeall](#sendmail-makeall)
	- [Class: sendmail::mc::define_section](#sendmail-mc-define_section)
	- [Class: sendmail::mc::enhdnsbl_section](#sendmail-mc-enhdnsbl_section)
	- [Class: sendmail::mc::feature_section](#sendmail-mc-feature_section)
	- [Class: sendmail::mc::local_config_section](#sendmail-mc-local_config_section)
	- [Class: sendmail::mc::macro_section](#sendmail-mc-macro_section)
	- [Class: sendmail::mc::mailer_section](#sendmail-mc-mailer_section)
	- [Class: sendmail::package](#sendmail-package)
	- [Class: sendmail::params](#sendmail-params)
	- [Class: sendmail::relay_domains::file](#sendmail-relay_domains-file)
	- [Class: sendmail::service](#sendmail-service)
	- [Class: sendmail::trusted_users::file](#sendmail-trusted_users-file)
	- [Class: sendmail::userdb::file](#sendmail-userdb-file)
	- [Class: sendmail::virtusertable::file](#sendmail-virtusertable-file)
- [**Defined Types**](#defined-types)
	- [Define: sendmail::access::entry](#sendmail-access-entry)
	- [Define: sendmail::aliases::entry](#sendmail-aliases-entry)
	- [Define: sendmail::authinfo::entry](#sendmail-authinfo-entry)
	- [Define: sendmail::domaintable::entry](#sendmail-domaintable-entry)
	- [Define: sendmail::genericstable::entry](#sendmail-genericstable-entry)
	- [Define: sendmail::local_host_names::entry](#sendmail-local_host_names-entry)
	- [Define: sendmail::mailertable::entry](#sendmail-mailertable-entry)
	- [Define: sendmail::mc::daemon_options](#sendmail-mc-daemon_options)
	- [Define: sendmail::mc::define](#sendmail-mc-define)
	- [Define: sendmail::mc::domain](#sendmail-mc-domain)
	- [Define: sendmail::mc::enhdnsbl](#sendmail-mc-enhdnsbl)
	- [Define: sendmail::mc::feature](#sendmail-mc-feature)
	- [Define: sendmail::mc::local_config](#sendmail-mc-local_config)
	- [Define: sendmail::mc::mailer](#sendmail-mc-mailer)
	- [Define: sendmail::mc::modify_mailer_flags](#sendmail-mc-modify_mailer_flags)
	- [Define: sendmail::mc::ostype](#sendmail-mc-ostype)
	- [Define: sendmail::mc::starttls](#sendmail-mc-starttls)
	- [Define: sendmail::mc::trust_auth_mech](#sendmail-mc-trust_auth_mech)
	- [Define: sendmail::mc::versionid](#sendmail-mc-versionid)
	- [Define: sendmail::relay_domains::entry](#sendmail-relay_domains-entry)
	- [Define: sendmail::trusted_users::entry](#sendmail-trusted_users-entry)
	- [Define: sendmail::userdb::entry](#sendmail-userdb-entry)
	- [Define: sendmail::virtusertable::entry](#sendmail-virtusertable-entry)
- [**Templates**](#templates)
- [**Augeas Lenses](#augeas-lenses)
	- [Augeas Lens: `sendmail_map](#lens: sendmail_map)

### Public Classes

#### Class: `sendmail`

Performs the basic setup and installation of Sendmail on the system.

**Parameters within `sendmail`:**

##### `smart_host`

Servers that are behind a firewall may not be able to deliver mail directly to the outside world. In this case the host may need to forward the mail to the gateway machine defined by this parameter. All nonlocal mail is forwarded to this gateway. Default value: undef.

##### `log_level`

The loglevel for the sendmail process. Valid options: a numeric value. Default value: undef.

##### `dont_probe_interfaces`

Sendmail normally probes all network interfaces to get the hostnames that the server may have. These hostnames are then considered local. This option can be used to prevent the reverse lookup of the network addresses. If this option is set to `localhost` then all network interfaces except for the loopback interface is probed. Valid options: the strings `true`, `false` or `localhost`. Default value: undef.

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

An array of hostnames that Sendmail considers for a local delivery. Default values: `[ $::fqdn ]`

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

The version id string included in the sendmail.mc file. This has no practical meaning other than having a used defined identifier in the file. Default value: undef.

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
#### Class: `sendmail::package`
#### Class: `sendmail::parameterfile`
#### Class: `sendmail::params`
#### Class: `sendmail::relay_domains`
#### Class: `sendmail::service`
#### Class: `sendmail::submit`
#### Class: `sendmail::trusted_users`
#### Class: `sendmail::userdb`
#### Class: `sendmail::virtusertable`

### Private Classes

#### Class: `sendmail::access::file`
#### Class: `sendmail::aliases::file`
#### Class: `sendmail::aliases::newaliases`
#### Class: `sendmail::authinfo::file`
#### Class: `sendmail::domaintable::file`
#### Class: `sendmail::genericstable::file`
#### Class: `sendmail::local_host_names::file`
#### Class: `sendmail::mailertable::file`
#### Class: `sendmail::makeall`
#### Class: `sendmail::mc::define_section`
#### Class: `sendmail::mc::enhdnsbl_section`
#### Class: `sendmail::mc::feature_section`
#### Class: `sendmail::mc::local_config_section`
#### Class: `sendmail::mc::macro_section`
#### Class: `sendmail::mc::mailer_section`
#### Class: `sendmail::relay_domains::file`
#### Class: `sendmail::trusted_users::file`
#### Class: `sendmail::userdb::file`
#### Class: `sendmail::virtusertable::file`

### Defined Types

#### Define: `sendmail::access::entry`
#### Define: `sendmail::aliases::entry`
#### Define: `sendmail::authinfo::entry`
#### Define: `sendmail::domaintable::entry`
#### Define: `sendmail::genericstable::entry`
#### Define: `sendmail::local_host_names::entry`
#### Define: `sendmail::mailertable::entry`
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
#### Define: `sendmail::relay_domains::entry`
#### Define: `sendmail::trusted_users::entry`
#### Define: `sendmail::userdb::entry`
#### Define: `sendmail::virtusertable::entry`

### Templates

The Sendmail module uses templates to build the `sendmail.mc` and `submit.mc` files. These are not meant for user configuration.

### Augeas Lenses

#### Augeas Lens: `sendmail_map`

The Sendmail module contains the Augeas lens `sendmail_map`. This lens has been built to easily manage entries in various Sendmail files (e.g. `mailertable`, `access_db`, ...). The lens is used by the provided module classes and so there should not be any need to call this lens directly.

## Limitations

The Sendmail module is currently developed and tested on:
* Debian 7 (Wheezy)
* Debian 8 (Jessie)

More supported operating systems are planned in future releases.

## Development

Sendmail is a powerful tool with many configuration options. The module includes configuration options I considered useful or needed for my own environment.

You may open Github issues for this module if you need additional configuration file options currently not available.

Feel free to send pull requests for new features.
