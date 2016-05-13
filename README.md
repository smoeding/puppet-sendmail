# sendmail

[![Build Status](https://travis-ci.org/smoeding/puppet-sendmail.svg?branch=master)](https://travis-ci.org/smoeding/puppet-sendmail)
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

The sendmail module uses a custom Augeas lense so the Puppet configuration setting `pluginsync` must be enabled. It also requires the Puppetlabs modules `stdlib` and `concat`.

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

With the Sendmail module these settings are defined by adding resources using the [`sendmail::mc::define`](#define-sendmailmcdefine) or [`sendmail::mc::feature`](#define-sendmailmcfeature) defined types.

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

See the [Reference](#reference) section for the complete list of available types that can be used.

### Most hosts do not need to receive mail

Use the [`sendmail::nullclient`](#class-sendmailnullclient) class to create a setup where no mail can be received from the outside and all local mail is forwarded to a central mail hub. This configuration is appropriate for the majority of satellite hosts.

```puppet
class { 'sendmail::nullclient':
  mail_hub => '[192.168.1.1]',
}
```

### I already have a working config and like to keep it

Disable the internal management of the sendmail configuration files by setting the parameters [`manage_sendmail_mc`](#manage_sendmail_mc) or [`manage_submit_mc`](#manage_submit_mc) to `false`:

```puppet
class { 'sendmail':
  manage_sendmail_mc => false,
  manage_submit_mc   => false,
}
```

> **Note**: These settings also disable the automatic generation of the `sendmail.cf` and `submit.cf` files. You will have to do that yourself if you change one of the files.

### I am behind a firewall and need to forward outgoing mail to a relay host

Use the [`smart_host`](#smart_host) parameter to set the host where all outgoing mail should be forwarded to.

```puppet
class { 'sendmail':
  smart_host => 'relay.example.com',
}
```

### I have a host that should not receive any mail from the outside

You can use the [`enable_ipv4_daemon`](#enable_ipv4_daemon) and [`enable_ipv6_daemon`](#enable_ipv6_daemon) parameters to prevent Sendmail from listening on all available network interfaces. Use the [`sendmail::mc::daemon_options`](#define-sendmailmcdaemon_options) defined type to explicitly define the addresses to use.

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

- [**Public Classes**](#public-classes)
  - [Class: sendmail](#class-sendmail)
  - [Class: sendmail::nullclient](#class-sendmailnullclient)
  - [Class: sendmail::aliases](#class-sendmailaliases)
  - [Class: sendmail::access](#class-sendmailaccess)
  - [Class: sendmail::domaintable](#class-sendmaildomaintable)
  - [Class: sendmail::genericstable](#class-sendmailgenericstable)
  - [Class: sendmail::mailertable](#class-sendmailmailertable)
  - [Class: sendmail::userdb](#class-sendmailuserdb)
  - [Class: sendmail::virtusertable](#class-sendmailvirtusertable)
  - [Class: sendmail::mc::privacy_flags](#class-sendmailmcprivacy_flags)
  - [Class: sendmail::mc::timeouts](#class-sendmailmctimeouts)
- [**Private Classes**](#private-classes)
  - [Class: sendmail::mc](#class-sendmailmc)
  - [Class: sendmail::submit](#class-sendmailsubmit)
  - [Class: sendmail::local_host_names](#class-sendmaillocal_host_names)
  - [Class: sendmail::relay_domains](#class-sendmailrelay_domains)
  - [Class: sendmail::trusted_users](#class-sendmailtrusted_users)
  - [Class: sendmail::aliases::newaliases](#class-sendmailaliasesnewaliases)
  - [Class: sendmail::makeall](#class-sendmailmakeall)
  - [Class: sendmail::package](#class-sendmailpackage)
  - [Class: sendmail::params](#class-sendmailparams)
  - [Class: sendmail::service](#class-sendmailservice)
  - [Class: sendmail::mc::starttls](#class-sendmailmcstarttls)
  - [Classes: sendmail::*::file](#classes-sendmailfile)
  - [Classes: sendmail::mc::*_section](#classes-sendmailmc_section)
- [**Public Defined Types**](#public-defined-types)
  - [Define: sendmail::aliases::entry](#define-sendmailaliasesentry)
  - [Define: sendmail::authinfo::entry](#define-sendmailauthinfoentry)
  - [Define: sendmail::access::entry](#define-sendmailaccessentry)
  - [Define: sendmail::domaintable::entry](#define-sendmaildomaintableentry)
  - [Define: sendmail::genericstable::entry](#define-sendmailgenericstableentry)
  - [Define: sendmail::mailertable::entry](#define-sendmailmailertableentry)
  - [Define: sendmail::userdb::entry](#define-sendmailuserdbentry)
  - [Define: sendmail::virtusertable::entry](#define-sendmailvirtusertableentry)
  - [Define: sendmail::mc::daemon_options](#define-sendmailmcdaemon_options)
  - [Define: sendmail::mc::define](#define-sendmailmcdefine)
  - [Define: sendmail::mc::domain](#define-sendmailmcdomain)
  - [Define: sendmail::mc::enhdnsbl](#define-sendmailmcenhdnsbl)
  - [Define: sendmail::mc::feature](#define-sendmailmcfeature)
  - [Define: sendmail::mc::include](#define-sendmailmcinclude)
  - [Define: sendmail::mc::ldaproute_domain](#define-sendmailmcldaproute_domain)
  - [Define: sendmail::mc::local_config](#define-sendmailmclocal_config)
  - [Define: sendmail::mc::mailer](#define-sendmailmcmailer)
  - [Define: sendmail::mc::masquerade_as](#define-sendmailmcmasquerade_as)
  - [Define: sendmail::mc::milter](#define-sendmailmcmilter)
  - [Define: sendmail::mc::modify_mailer_flags](#define-sendmailmcmodify_mailer_flags)
  - [Define: sendmail::mc::ostype](#define-sendmailmcostype)
  - [Define: sendmail::mc::trust_auth_mech](#define-sendmailmctrust_auth_mech)
  - [Define: sendmail::mc::versionid](#define-sendmailmcversionid)
- [**Augeas Lenses**](#augeas-lenses)
  - [Augeas Lens: sendmail_map](#augeas-lens-sendmail_map)
- [**Templates**](#templates)

### Public Classes

#### Class: `sendmail`

Performs the basic setup and installation of Sendmail on the system.

**Parameters for the `sendmail` class:**

##### `smart_host`

Servers behind a firewall may not be able to deliver mail directly to the outside world. In this case the host may need to forward the mail to a gateway machine defined by this parameter. All nonlocal mail is forwarded to this gateway. Default value: `undef`

##### `domain_name`

Sets the official canonical name of the local machine. Normally this parameter is not required as Sendmail uses the fully qualified domain name by default. Setting this parameter will override the value of the `$j` macro in the `sendmail.cf` file. Default value: `undef`

##### `max_message_size`

Define the maximum message size that will be accepted. This can be a pure numerical value given in bytes (e.g. `33554432`) or a number with a prefixed byte unit (e.g. `32MB`). The conversion is done using the 1024 convention (see the `to_bytes` function in the `stdlib` module), so valid prefixes are either `k` for 1024 bytes or `M` for 1048576 bytes. Default value: `undef`

##### `log_level`

The loglevel for the sendmail process. Valid options: a numeric value. Default value: `undef`

##### `dont_probe_interfaces`

Sendmail normally probes all network interfaces to get all hostnames that the server may have. These hostnames are then considered local. This option can be used to prevent the reverse lookup of the network addresses. If this option is set to `localhost` then all network interfaces except for the loopback interface is probed. Valid options: the strings `true`, `false` or `localhost`. Default value: `undef`

##### `enable_ipv4_daemon`

Should the host accept mail on all IPv4 network adresses. Valid options: `true` or `false`. Default value: `true`

##### `enable_ipv6_daemon`

Should the host accept mail on all IPv6 network adresses. Valid options: `true` or `false`. Default value: `true`

##### `mailers`

An array of mailers to add to the configuration. Default value: `[ 'smtp', 'local' ]`

##### `local_host_names`

An array of hostnames that Sendmail recognizes for local delivery. Default value: `[ $::fqdn ]`

##### `relay_domains`

An array of domains that Sendmail accepts as relay target. This setting is required for secondary MX setups. Default value: `[]`

##### `trusted_users`

An array of user names that will be written into the trusted users file. Leading or trailing whitespace is ignored. Empty entries are also ignored. Default value: `[]`

##### `trust_auth_mech`

The value of trusted authentication mechanisms to set. If this is a string it is used as-is. For an array the value will be concatenated into a string. Default value: `undef`

##### `ca_cert_file`

The filename of the SSL CA certificate. Default value: `undef`

##### `ca_cert_path`

The directory where SSL CA certificates are kept. Default value: `undef`

##### `server_cert_file`

The filename of the SSL server certificate for inbound connections. Default value: `undef`

##### `server_key_file`

The filename of the SSL server key for inbound connections. Default value: `undef`

##### `client_cert_file`

The filename of the SSL client certificate for outbound connections. Default value: `undef`

##### `client_key_file`

The filename of the SSL client key for outbound connections. Default value: `undef`

##### `crl_file`

The filename with a list of revoked certificates. Default value: `undef`

##### `dh_params`

The DH parameters used for encryption. This can be one of the numbers `512`, `1024`, `2048` or a filename with pregenerated parameters. Default value: `undef`

##### `cipher_list`

Set the available ciphers for encrypted connections. Default value: `undef`

##### `server_ssl_options`

Configure the SSL connection flags for inbound connections. Default value: `undef`

##### `client_ssl_options`

Configure the SSL connection flags for outbound connections. Default value: `undef`

##### `cf_version`

The configuration version string for Sendmail. This string will be appended to the Sendmail version in the HELO message. If unset, no configuration version will be used. Default value: `undef`

##### `version_id`

The version id string included in the `sendmail.mc` file. This has no practical meaning other than having a user defined identifier in the file. Default value: `undef`

##### `msp_host`

The host where the message submission program should deliver to. This can be a hostname or IP address. To prevent MX lookups for the host, put it in square brackets (e.g., `[hostname]`). Delivery to the local host would therefore use either `[127.0.0.1]` for IPv4 or `[IPv6:::1]` for IPv6. Default value: `[127.0.0.1]`

##### `msp_port`

The port used for the message submission program. Can be a port number (e.g., `25`) or the literal `MSA` for delivery to the message submission agent on port 587. Make sure to configure a daemon that listens on this port or local mail will remain stuck in the submission queue. Default value: `MSA`

##### `enable_msp_trusted_users`

Whether the trusted users file feature is enabled for the message submission program. This may be necessary if you want to allow certain users to change the sender address using `sendmail -f`. Valid options: `true` or `false`. Default value: `false`

##### `manage_sendmail_mc`

Whether to automatically manage the `sendmail.mc` file. Valid options: `true` or `false`. Default value: `true`

##### `manage_submit_mc`

Whether to automatically manage the `submit.mc` file. Valid options: `true` or `false`. Default value: `true`

##### `auxiliary_packages`

Additional packages that will be installed by the Sendmail module. Valid options: array of strings. Default value: varies by operating system.

##### `package_ensure`

Configure whether the Sendmail package should be installed, and what version. Valid options: `present`, `latest`, or a specific version number. Default value: `present`

##### `package_manage`

Configure whether Puppet should manage the Sendmail package(s). Valid options: `true` or `false`. Default value: `true`

##### `service_name`

The service name to use on this operating system.

##### `service_enable`

Configure whether the Sendmail MTA should be enabled at boot. Valid options: `true` or `false`. Default value: `true`

##### `service_manage`

Configure whether Puppet should manage the Sendmail service. Valid options: `true` or `false`. Default value: `true`

##### `service_ensure`

Configure whether the Sendmail service should be running. Valid options: `running` or `stopped`. Default value: `running`

##### `service_hasstatus`

Define whether the service type can rely on a working init script status. Valid options: `true` or `false`. Default value depends on the operating system and release.

#### Class: `sendmail::nullclient`

Create a simple Sendmail nullclient configuration. No mail can be received from the outside since the Sendmail daemon only listens on the localhost address `127.0.0.1`. All local mail is forwarded to a given mail hub.

This is a convenience class to make the configuration simple. Internally it declares the `sendmail` class using appropriate parameters. Normally no other configuration should be necessary.

```puppet
class { 'sendmail::nullclient':
  mail_hub           => '[192.168.1.1]',
  port_option_modify => 'S',
  enable_ipv6_msa    => false,
}
```

**Parameters for the `sendmail::nullclient` class:**

##### `mail_hub`

The hostname or IP address of the mail hub where all mail is forwarded to. It can be enclosed in brackets to prevent MX lookups.

##### `domain_name`

Sets the official canonical name of the local machine. Normally this parameter is not required as Sendmail uses the fully qualified domain name by default. Setting this parameter will override the value of the `$j` macro in the `sendmail.cf` file. Default value: `undef`

##### `max_message_size`

Define the maximum message size that will be accepted. This can be a pure numerical value given in bytes (e.g. `33554432`) or a number with a prefixed byte unit (e.g. `32MB`). The conversion is done using the 1024 convention (see the `to_bytes` function in the `stdlib` module), so valid prefixes are either `k` for 1024 bytes or `M` for 1048576 bytes. Default value: `undef`

##### `log_level`

The loglevel for the sendmail process. Valid options: a numeric value. Default value: `undef`

##### `enable_ipv4_msa`

Enable the local message submission agent on the IPv4 loopback address (`127.0.0.1`). Valid options: `true` or `false`. Default value: `true`

##### `enable_ipv6_msa`

Enable the local message submission agent on the IPv6 loopback address (`::1`). Valid options: `true` or `false`. Default value: `true`

##### `port`

The port used for the local message submission agent. Default value: `587`

##### `port_option_modify`

Port option modifiers for the local message submission agent. This parameter is used for the daemon port options. A useful value for the nullclient configuration might be `S` to prevent offering STARTTLS on the MSA port. Default value: `undef`

##### `enable_msp_trusted_users`

Whether the trusted users file feature is enabled for the message submission program. This may be necessary if you want to allow certain users to change the sender address using `sendmail -f`. Valid options: `true` or `false`. Default value: `false`

##### `trusted_users`

An array of user names that will be written into the trusted users file. Leading or trailing whitespace is ignored. Empty entries are also ignored. Default value: `[]`

##### `ca_cert_file`

The filename of the SSL CA certificate. Default value: `undef`

##### `ca_cert_path`

The directory where SSL CA certificates are kept. Default value: `undef`

##### `server_cert_file`

The filename of the SSL server certificate for inbound connections. Default value: `undef`

##### `server_key_file`

The filename of the SSL server key for inbound connections. Default value: `undef`

##### `client_cert_file`

The filename of the SSL client certificate for outbound connections. Default value: `undef`

##### `client_key_file`

The filename of the SSL client key for outbound connections. Default value: `undef`

##### `crl_file`

The filename with a list of revoked certificates. Default value: `undef`

##### `dh_params`

The DH parameters used for encryption. This can be one of the numbers `512`, `1024`, `2048` or a filename with pregenerated parameters. Default value: `undef`

##### `cipher_list`

Set the available ciphers for encrypted connections. Default value: `undef`

##### `server_ssl_options`

Configure the SSL connection flags for inbound connections. Default value: `undef`

##### `client_ssl_options`

Configure the SSL connection flags for outbound connections. Default value: `undef`

#### Class: `sendmail::aliases`

Manage the Sendmail aliases file. The class manages the file either as a single file resource or each entry in the file separately.

The file is managed as a whole using the `source` or `content` parameters.

```puppet
class { 'sendmail::aliases':
  source => 'puppet:///modules/site/aliases',
}
```

The `entries` parameter is used to manage each entry separately. Preferable this is done with hiera using automatic parameter lookup.

```puppet
class { 'sendmail::aliases': }
```

**Parameters for the `sendmail::aliases` class:**

##### `content`

The desired contents of the aliases file. This allows managing the aliases file as a whole. Changes to the file automatically triggers a rebuild of the aliases database file. This attribute is mutually exclusive with `source` and `entries`.

##### `source`

A source file for the aliases file. This allows managing the aliases file as a whole. Changes to the file automatically triggers a rebuild of the aliases database file. This attribute is mutually exclusive with `content` and `entries`.

##### `entries`

A hash that will be used to create [`sendmail::aliases::entry`](#define-sendmailaliasesentry) resources. This attribute is mutually exclusive with `content` and `source`.

The class can be used to create aliases defined in hiera. The hiera hash should look like this:

```yaml
sendmail::aliases::entries:
  'fred':
	recipient: 'barney@example.org'
```

#### Class: `sendmail::access`

Manage the Sendmail access db file. The class manages the file either as a single file resource or each entry in the file separately.

The file is managed as a whole using the `source` or `content` parameters.

```puppet
class { 'sendmail::access':
  source => 'puppet:///modules/site/access',
}
```

The `entries` parameter is used to manage each entry separately. Preferable this is done with hiera using automatic parameter lookup.

```puppet
class { 'sendmail::access': }
```

**Parameters for the `sendmail::access` class:**

##### `content`

The desired contents of the access file. This allows managing the access file as a whole. Changes to the file automatically triggers a rebuild of the access database file. This attribute is mutually exclusive with `source` and `entries`.

##### `source`

A source file for the access file. This allows managing the access file as a whole. Changes to the file automatically triggers a rebuild of the access database file. This attribute is mutually exclusive with `content` and `entries`.

##### `entries`

A hash that will be used to create [`sendmail::access::entry`](#define-sendmailaccessentry) resources. This attribute is mutually exclusive with `content` and `source`.

The class can be used to create access entries defined in hiera. The hiera hash should look like this:

```yaml
sendmail::access::entries:
  'example.com':
	value: 'OK'
  'example.org':
	value: 'REJECT'
```

#### Class: `sendmail::domaintable`

Manage the Sendmail domaintable file. The class manages the file either as a single file resource or each entry in the file separately.

The file is managed as a whole using the `source` or `content` parameters.

```puppet
class { 'sendmail::domaintable':
  source => 'puppet:///modules/site/domaintable,
}
```

The `entries` parameter is used to manage each entry separately. Preferable this is done with hiera using automatic parameter lookup.

```puppet
class { 'sendmail::domaintable': }
```

**Parameters for the `sendmail::domaintable` class:**

##### `content`

The desired contents of the domaintable file. This allows managing the domaintable file as a whole. Changes to the file automatically triggers a rebuild of the domaintable database file. This attribute is mutually exclusive with `source` and `entries`.

##### `source`

A source file for the domaintable file. This allows managing the domaintable file as a whole. Changes to the file automatically triggers a rebuild of the domaintable database file. This attribute is mutually exclusive with `content` and `entries`.

##### `entries`

A hash that will be used to create [`sendmail::domaintable::entry`](#define-sendmaildomaintableentry) resources. This attribute is mutually exclusive with `content` and `source`.

This class can be used to create domaintable entries defined in hiera. The hiera hash should look like this:

```yaml
sendmail::domaintable::entries:
  'example.com':
	value: 'example.org'
  'example.net':
	value: 'example.org'
```

#### Class: `sendmail::genericstable`

Manage the Sendmail genericstable file. The class manages the file either as a single file resource or each entry in the file separately.

The file is managed as a whole using the `source` or `content` parameters.

```puppet
class { 'sendmail::genericstable':
  source => 'puppet:///modules/site/genericstable',
}
```

The `entries` parameter is used to manage each entry separately. Preferable this is done with hiera using automatic parameter lookup.

```puppet
class { 'sendmail::genericstable': }
```

**Parameters for the `sendmail::genericstable` class:**

##### `content`

The desired contents of the genericstable file. This allows managing the genericstable file as a whole. Changes to the file automatically triggers a rebuild of the genericstable database file. This attribute is mutually exclusive with `source` and `entries`.

##### `source`

A source file for the genericstable file. This allows managing the genericstable file as a whole. Changes to the file automatically triggers a rebuild of the genericstable database file. This attribute is mutually exclusive with `content` and `entries`.

##### `entries`

A hash that will be used to create [`sendmail::genericstable::entry`](#define-sendmailgenericstableentry) resources. This attribute is mutually exclusive with `content` and `source`.

This class can be used to create genericstable entries defined in hiera. The hiera hash should look like this:

```yaml
sendmail::genericstable::entries:
  'fred@example.com':
	value: 'fred@example.org'
  'barney':
	value: 'barney@example.org'
```

#### Class: `sendmail::mailertable`

Manage the Sendmail mailertable file. The class manages the file either as a single file resource or each entry in the file separately.

The file is managed as a whole using the `source` or `content` parameters.

```puppet
class { 'sendmail::mailertable':
  source => 'puppet:///modules/site/mailertable',
}
```

The `entries` parameter is used to manage each entry separately. Preferable this is done with hiera using automatic parameter lookup.

```puppet
class { 'sendmail::mailertable': }
```

**Parameters for the `sendmail::mailertable` class:**

##### `content`

The desired contents of the mailertable file. This allows managing the mailertable file as a whole. Changes to the file automatically triggers a rebuild of the mailertable database file. This attribute is mutually exclusive with `source` and `entries`.

##### `source`

A source file for the mailertable file. This allows managing the mailertable file as a whole. Changes to the file automatically triggers a rebuild of the mailertable database file. This attribute is mutually exclusive with `content` and `entries`.

##### `entries`

A hash that will be used to create [`sendmail::mailertable::entry`](#define-sendmailmailertableentry) resources. This attribute is mutually exclusive with `content` and `source`.

This class can be used to create mailertable entries defined in hiera. The hiera hash should look like this:

```yaml
sendmail::mailertable::entries:
  '.example.com':
	value: 'smtp:relay.example.com'
  'www.example.org':
	value: 'relay:relay.example.com'
  '.example.net':
	value: 'error:5.7.0:550 mail is not accepted'
```

#### Class: `sendmail::userdb`

Manage the Sendmail userdb file. The class manages the file either as a single file resource or each entry in the file separately.

The file is managed as a whole using the `source` or `content` parameters.

```puppet
class { 'sendmail::userdb':
  source => 'puppet:///modules/site/userdb',
}
```

The `entries` parameter is used to manage each entry separately. Preferable this is done with hiera using automatic parameter lookup.

```puppet
class { 'sendmail::userdb': }
```

**Parameters for the `sendmail::userdb` class:**

##### `content`

The desired contents of the userdb file. This allows managing the userdb file as a whole. Changes to the file automatically triggers a rebuild of the userdb database file. This attribute is mutually exclusive with `source` and `entries`.

##### `source`

A source file for the userdb file. This allows managing the userdb file as a whole. Changes to the file automatically triggers a rebuild of the userdb database file. This attribute is mutually exclusive with `content` and `entries`.

##### `entries`

A hash that will be used to create [`sendmail::userdb::entry`](#define-sendmailuserdbentry) resources. This attribute is mutually exclusive with `content` and `source`.

This class can be used to create userdb entries defined in hiera. The hiera hash should look like this:

```yaml
sendmail::userdb::entries:
  'fred:maildrop':
	value: 'fred@example.org'
  'barney:maildrop':
	value: 'barney@example.org'
```

#### Class: `sendmail::virtusertable`

Manage the Sendmail virtusertable file. The class manages the file either as a single file resource or each entry in the file separately.

The file is managed as a whole using the `source` or `content` parameters.

```puppet
class { 'sendmail::virtusertable':
  source => 'puppet:///modules/site/virtusertable',
}
```

The `entries` parameter is used to manage each entry separately. Preferable this is done with hiera using automatic parameter lookup.

```puppet
class { 'sendmail::virtusertable': }
```

**Parameters for the `sendmail::virtusertable` class:**

##### `content`

The desired contents of the virtusertable file. This allows managing the virtusertable file as a whole. Changes to the file automatically triggers a rebuild of the virtusertable database file. This attribute is mutually exclusive with `source` and `entries`.

##### `source`

A source file for the virtusertable file. This allows managing the virtusertable file as a whole. Changes to the file automatically triggers a rebuild of the virtusertable database file. This attribute is mutually exclusive with `content` and `entries`.

##### `entries`

A hash that will be used to create [`sendmail::virtusertable::entry`](#define-sendmailvirtusertableentry) resources. This attribute is mutually exclusive with `content` and `source`.

This class can be used to create virtusertable entries defined in hiera. The hiera hash should look like this:

```yaml
sendmail::virtusertable::entries:
  'info@example.com':
	value: 'fred'
  '@example.org':
	value: 'barney'
```

#### Class: `sendmail::mc::privacy_flags`

This class defines privacy options for the main Sendmail daemon. Each option is enabled by setting the associated boolean parameter to `true`. See the Sendmail documentation for the meaning of the flags.

```puppet
class { 'sendmail::mc::privacy_flags':
  goaway         => true,
  restrictexpand => true,
  noetrn         => true,
}
```

**Parameters for the `sendmail::mc::privacy_flags` class:**

##### `authwarnings`

Whether the privacy option of the same name should be enabled. Valid options: `true` or `false`. Default value: `false`

##### `goaway`

Whether the privacy option of the same name should be enabled. Valid options: `true` or `false`. Default value: `false`

##### `needexpnhelo`

Whether the privacy option of the same name should be enabled. Valid options: `true` or `false`. Default value: `false`

##### `needmailhelo`

Whether the privacy option of the same name should be enabled. Valid options: `true` or `false`. Default value: `false`

##### `needvrfyhelo`

Whether the privacy option of the same name should be enabled. Valid options: `true` or `false`. Default value: `false`

##### `noactualrecipient`

Whether the privacy option of the same name should be enabled. Valid options: `true` or `false`. Default value: `false`

##### `nobodyreturn`

Whether the privacy option of the same name should be enabled. Valid options: `true` or `false`. Default value: `false`

##### `noetrn`

Whether the privacy option of the same name should be enabled. Valid options: `true` or `false`. Default value: `false`

##### `noexpn`

Whether the privacy option of the same name should be enabled. Valid options: `true` or `false`. Default value: `false`

##### `noreceipts`

Whether the privacy option of the same name should be enabled. Valid options: `true` or `false`. Default value: `false`

##### `noverb`

Whether the privacy option of the same name should be enabled. Valid options: `true` or `false`. Default value: `false`

##### `novrfy`

Whether the privacy option of the same name should be enabled. Valid options: `true` or `false`. Default value: `false`

##### `public`

Whether the privacy option of the same name should be enabled. Valid options: `true` or `false`. Default value: `false`

##### `restrictexpand`

Whether the privacy option of the same name should be enabled. Valid options: `true` or `false`. Default value: `false`

##### `restrictmailq`

Whether the privacy option of the same name should be enabled. Valid options: `true` or `false`. Default value: `false`

##### `restrictqrun`

Whether the privacy option of the same name should be enabled. Valid options: `true` or `false`. Default value: `false`

#### Class: `sendmail::mc::timeouts`

This class allows setting various timeouts for Sendmail without having to use the [`sendmail::mc::define`](#define-sendmailmcdefine) macro individually for each entry.

```puppet
class { 'sendmail::mc::timeouts':
  ident => '0',
}
```

**Parameters for the `sendmail::mc::timeouts` class:**

##### `aconnect`

Timeout for all connection attempts when trying to reach one or multiple hosts for  sending a single mail. Default value: undef

##### `auth`

Timeout when waiting for AUTH negotiation. Default value: undef

##### `command`

Timeout when waiting for the next SMTP command. Default value: undef

##### `connect`

Timeout for one connection attempt when trying to establish a network connection. Also see then 'iconnect' parameter. Default value: undef

##### `control`

Timout when waiting for a command on the control socket. Default value: undef

##### `datablock`

Timeout when waiting on a read operation during the DATA phase. Default value: undef

##### `datafinal`

Timeout when waiting for the acknowledgment after sending the final dot in the DATA phase. Default value: undef

##### `datainit`

Timeout when waiting for the acknowledgment of the DATA command. Default value: undef

##### `fileopen`

Timeout when waiting for access to a local file. Default value: undef

##### `helo`

Timeout when waiting for the acknowledgment of the HELO or EHLO commands. Default value: undef

##### `hoststatus`

Timeout for invalidation of hoststatus information during a single queue run. Default value: undef

##### `iconnect`

Timeout for the first connection attempt to a host when trying to establish a network connection. Also see then 'connect' parameter. Default value: undef

##### `ident`

Timeout when waiting to a response to a RFC1413 identification protocol query. Set this to '0' to disable the identification protocol. Default value: undef

##### `initial`

Timeout when waiting for the initial greeting message. Default value: undef
#
##### `lhlo`

Timeout when waiting for the reply to the initial LHLO command on an LMTP connection. Default value: undef

##### `mail`

Timeout when waiting for the acknowledgment of the MAIL command. Default value: undef

##### `misc`

Timeout when waiting for the acknowledgment of various other commands (VERB, NOOP, ...). Default value: undef

##### `quit`

Timeout when waiting for the acknowledgment of the QUIT command. Default value: undef

##### `rcpt`

Timeout when waiting for the acknowledgment of the RCPT command. Default value: undef

##### `rset`

Timeout when waiting for the acknowledgment of the RSET command. Default value: undef

##### `starttls`

Timeout when waiting for STARTTLS negotiation. Default value: undef

### Private Classes

#### Class: `sendmail::mc`

Manage the `sendmail.mc` file. This class uses the `concat` module to create configuration fragments to assemble the final configuration file.

On FreeBSD the daemon configuration file is named after the hostname of the server. In this case the class also manages a symbolic link in `/etc/mail` to reference the file.

#### Class: `sendmail::submit`

Manage the `submit.mc` file that contains the configuration for the local message submission program.

On FreeBSD the submit configuration file is named after the hostname of the server. In this case the class also manages a symbolic link in `/etc/mail` to reference the file.

#### Class: `sendmail::local_host_names`

Manage entries in the Sendmail local-host-names file. Do not declare this class directly. Use the [`local_host_names`](#local_host_names) parameter of the [`sendmail`](#class-sendmail) class instead.

#### Class: `sendmail::relay_domains`

Manage entries in the Sendmail relay-domains file. Do not declare this class directly. Use the [`relay_domains`](#relay_domains) parameter of the [`sendmail`](#class-sendmail) class instead.

#### Class: `sendmail::trusted_users`

Manage entries in the Sendmail trusted-users file. Do not declare this class directly. Use the [`trusted_users`](#trusted_users) parameter of the [`sendmail`](#class-sendmail) class instead.

#### Class: `sendmail::aliases::newaliases`

Trigger the rebuild of the alias database after modifying an entry in the aliases file. This class is notified automatically when an alias is managed using the [`sendmail::aliases::entry`](define-sendmailaliasesentry) defined type.

#### Class: `sendmail::makeall`

Triggers the rebuild of various Sendmail files. This includes conversion of `sendmail.mc` into `sendmail.cf` and generation of the Sendmail database map files.

#### Class: `sendmail::package`

Installs the necessary Sendmail packages.

#### Class: `sendmail::params`

The parameter class that contains operating specific values.

#### Class: `sendmail::service`

Manages the Sendmail service.

#### Class: `sendmail::mc::starttls`

Manage the `STARTTLS` configuration for Sendmail. This class is included by the main [`sendmail`](#class-sendmail) class and should not be used directly.

#### Classes: `sendmail::*::file`

These classes manage the various Sendmail database files and ensure correct owner, group and permissions. Modifications of the files also trigger a rebuild of the corresponding database file.

#### Classes: `sendmail::mc::*_section`

These classes are included by some of the `sendmail::mc::*` defined types to create a suitable section header in the generated `sendmail.mc` file. The sole purpose is to improve the readability of the generated file.

### Public Defined Types

#### Define: `sendmail::aliases::entry`

Manage an entry in the Sendmail alias file. The type has an internal dependency to rebuild the aliases database file.

```puppet
sendmail::aliases::entry { 'fred':
  recipient => 'barney@example.org',
}
```

**Parameters for the `sendmail::aliases::entry` type:**

##### `recipient`

The recipient where the mail is redirected to.

##### `ensure`

Used to create or remove the alias entry. Valid options: `present`, `absent`. Default value: `present`

#### Define: `sendmail::authinfo::entry`

Manage an entry in the Sendmail authinfo db file. The type has an internal dependency to rebuild the database file.

```puppet
sendmail::authinfo::entry { 'example.com':
  password         => 'secret',
  authorization_id => 'auth',
}
```

**Parameters for the `sendmail::authinfo::entry` type:**

##### `password`

The password used for remote authentication in clear text. Exactly one of `password` or `password_base64` must be set. Default value: `undef`

##### `password_base64`

The password used for remote authentication in Base64 encoding. Exactly one of `password` or `password_base64` must be set. Default value: `undef`

##### `authorization_id`

The user (authorization) identifier. One of the parameters `authorization_id` or `authentication_id` or both must be set. Default value: `undef`

##### `authentication_id`

The authentication identifier. One of the parameters `authorization_id` or `authentication_id` or both must be set. Default value: `undef`

##### `realm`

The administrative realm to use. Default value: `undef`

##### `mechanisms`

The list of preferred authentication mechanisms. Default value: `[]`

##### `address`

The key used by Sendmail for the database lookup. This can be an IPv4 address (e.g. `192.168.67.89`), an IPv6 address (e.g. `IPv6:2001:DB18::23f4`), a hostname (e.g. `www.example.org`) or a domain name (e.g. `example.com`). The database key requires to start with the literal expression `AuthInfo:`. This prefix will be added automatically if necessary. Default value is the resource title.

##### `ensure`

Used to create or remove the authinfo db entry. Valid options: `present`, `absent`. Default value: `present`

#### Define: `sendmail::access::entry`

Manage an entry in the Sendmail access db file. The type has an internal dependency to rebuild the database file.

```puppet
sendmail::access::entry { 'example.com':
  value => 'RELAY',
}
```

**Parameters for the `sendmail::access::entry` type:**

##### `key`

The key used by Sendmail for the lookup. This could for example be a domain name. Default is the resource title.

##### `value`

The value for the given key. For the access map this is typically something like `OK`, `REJECT` or `DISCARD`.

##### `ensure`

Used to create or remove the access db entry. Valid options: `present`, `absent`. Default value: `present`

#### Define: `sendmail::domaintable::entry`

Manage an entry in the Sendmail domaintable db file. The type has an internal dependency to rebuild the database file.

```puppet
sendmail::domaintable::entry { 'example.com':
  value => 'example.org',
}
```

**Parameters for the `sendmail::domaintable::entry` type:**

##### `key`

The key used by Sendmail for the lookup. This should normally be a domain name. Default is the resource title.

##### `value`

The value for the given key. For the domaintable map this is typically another domain name.

##### `ensure`

Used to create or remove the domaintable db entry. Valid options: `present`, `absent`. Default value: `present`

#### Define: `sendmail::genericstable::entry`

Manage an entry in the Sendmail genericstable db file. The type has an internal dependency to rebuild the database file.

```puppet
sendmail::genericstable::entry { 'fred@example.com':
  value => 'fred@example.org',
}
```

```puppet
sendmail::genericstable::entry { 'barney':
  value => 'barney@example.org',
}
```

**Parameters for the `sendmail::genericstable::entry` type:**

##### `key`

The key used by Sendmail for the lookup. This is normally a username or a user and domain name. Default is the resource title.

##### `value`

The value for the given key. For the genericstable map this is typically something like `user@example.org`.

##### `ensure`

Used to create or remove the genericstable db entry. Valid options: `present`, `absent`. Default value: `present`

#### Define: `sendmail::mailertable::entry`

Manage an entry in the Sendmail mailertable db file. The type has an internal dependency to rebuild the database file.

```puppet
sendmail::mailertable::entry { '.example.com':
  value => 'smtp:relay.example.com',
}
```

```puppet
sendmail::mailertable::entry { '.example.net':
  value => 'error:5.7.0:550 mail is not accepted',
}
```

**Parameters for the `sendmail::mailertable::entry` type:**

##### `key`

The key used by Sendmail for the lookup. This should either be a fully qualified host name or a domain name with a leading dot. Default is the resource title.

##### `value`

The value for the given key. For the mailertable map this is typically something like `smtp:hostname`. The error mailer can be used to configure specific errors for certain hosts.

##### `ensure`

Used to create or remove the mailertable db entry. Valid options: `present`, `absent`. Default value: `present`

#### Define: `sendmail::userdb::entry`

Manage entries in the Sendmail userdb db file. The type has an internal dependency to rebuild the database file.

```puppet
sendmail::userdb::entry { 'fred:maildrop':
  value => 'fred@example.org',
}
```

**Parameters for the `sendmail::userdb::entry` type:**

##### `key`

The key used by Sendmail for the lookup. This normally is in the format `user:maildrop` or `user:mailname` where user is the a local username. Default is the resource title.

##### `value`

The value for the given key. For the userdb map this is typically a single mailaddress or a compound list of addresses separated by commas.

##### `ensure`

Used to create or remove the userdb db entry. Valid options: `present`, `absent`. Default value: `present`

#### Define: `sendmail::virtusertable::entry`

Manage entries in the Sendmail virtusertable db file. The type has an internal dependency to rebuild the database file.

```puppet
sendmail::virtusertable::entry { 'info@example.com':
  value => 'fred@example.com',
}
```

```puppet
sendmail::virtusertable::entry { '@example.org':
  value => 'barney',
}
```

**Parameters for the `sendmail::virtusertable::entry` type:**

##### `key`

The key used by Sendmail for the lookup. This is normally a mail address or a mail address without the user part. Default is the resource title.

##### `value`

The value for the given key. For the virtusertable map this is typically a local username or a remote mail address.

##### `ensure`

Used to create or remove the virtusertable db entry. Valid options: `present`, `absent`. Default value: `present`

#### Define: `sendmail::mc::daemon_options`

Add a `DAEMON_OPTIONS` macro to the `sendmail.mc` file.

```puppet
sendmail::mc::daemon_options { 'MTA-v4':
  daemon_name => 'MTA',
  family      => 'inet',
  port        => '25',
}
```

**Parameters for the `sendmail::mc::daemon_options` type:**

##### `daemon_name`

The name of the daemon to use for this entry. The logfile will contain the name to identify the daemon. Default is the resource title.

##### `family`

The network family type. Valid options: `inet`, `inet6` or `iso`

##### `addr`

The network address to listen on for remote connections. This can be a hostname or network address.

##### `port`

The port used by the daemon. This can be either a numeric port number or a service name like `smtp` for port 25 or `submission` for port 587.

##### `children`

The maximum number of processes to fork for this daemon.

##### `delivery_mode`

The mode of delivery for this daemon. Valid options: `background`, `deferred`, `interactive` or `queueonly`.

##### `input_filter`

A list of milters to use. This can either be an array of milter names or a single string, where the milter names are separated by colons.

##### `listen`

The length of the listen queue used by the operating system.

##### `modify`

Single letter flags to modify the daemon behaviour. See the Sendmail documention for details.

##### `delay_la`

The local load average at which connections are delayed before they are accepted.

##### `queue_la`

The local load average at which received mail is queued and not delivered immediately.

##### `refuse_la`

The local load average at which mail is no longer accepted.

##### `send_buf_size`

The size of the network send buffer used by the operating system. The value is a size in bytes.

##### `receive_buf_size`

The size of the network receive buffer used by the operating system. The value is a size in bytes.

#### Define: `sendmail::mc::define`

Add a m4 macro `define` to the `sendmail.mc` file.

```puppet
sendmail::mc::define { 'confLOG_LEVEL':
  expansion  => '12',
}
```

**Parameters for the `sendmail::mc::define` type:**

##### `macro_name`

The name of the macro that will be defined. This will be the first argument of the m4 define builtin. Default is the resource title.

> **Note**: The macro name should not be quoted as it will always be quoted in the template.

##### `expansion`

The expansion defined for the macro.

##### `use_quotes`

A boolean that indicates if the expansion should be quoted (using m4 quotes). If this argument is `true`, then the expansion will be enclosed in \` and ' symbols in the generated output file. A value of `false` prevents automatic quotes. This is useful if the expansion references another macro. In this case the correct quotes have to be set manually. Valid options: `true` or `false`. Default value: `true`

> **Note**: The name of the defined macro will always be quoted.

#### Define: `sendmail::mc::domain`

Add the `DOMAIN` macro to the `sendmail.mc` file.

```puppet
sendmail::mc::domain { 'generic': }
```

**Parameters for the `sendmail::mc::domain` type:**

##### `domain`

The name of the sendmail domain file as a string. The value is used as argument to the `DOMAIN` macro to the generated `sendmail.mc` file. This will include the m4 file with domain specific settings. Default is the resource title.

#### Define: `sendmail::mc::enhdnsbl`

Manage enhanced DNS blacklist entries.

```puppet
sendmail::mc::enhdnsbl { 'dialups.mail-abuse.org':
  reject_message          => '"550 dial-up site refused"',
  allow_temporary_failure => true,
  lookup_result           => '127.0.0.3.',
}
```

**Parameters for the `sendmail::mc::enhdnsbl` type:**

##### `blacklist`

The DNS name to query the blacklist. This defaults to the resource title.

##### `reject_message`

The error message used when a message is rejected.

##### `allow_temporary_failure`

Determine what happens when a temporary failure of the DNS lookup occurs. The message is accepted when this parameter is set to `false` (the default). A temporary error is signaled when this is set to `true`.

##### `lookup_result`

Check the DNS lookup for this result. Leave this parameter unset to block the message as long as anything is returned from the lookup.

#### Define: `sendmail::mc::feature`

Add a `FEATURE` macro to the `sendmail.mc` file.

```puppet
sendmail::mc::feature { 'mailertable': }
```

```puppet
sendmail::mc::feature { 'mailertable':
  args => 'hash /etc/mail/mailertable',
}
```

```puppet
sendmail::mc::feature { 'mailertable':
  args       => [ '`hash /etc/mail/mailertable\'' ],
  use_quotes => false,
}
```

**Parameters for the `sendmail::mc::feature` type:**

##### `feature_name`

The name of the feature that will be used. This will be the first argument of the `FEATURE`. Defaults to the resource title.

> **Note**: The feature name should not be quoted as it will always be quoted in the template.

##### `args`

The arguments used for the feature. This can be a simple string, if the feature takes only one argument. If the feature requires more than one argument, it must be an array of strings. Default value: `[]`

##### `use_quotes`

A boolean that indicates if the arguments should be quoted (using m4 quotes). If this argument is `true`, then the arguments will be enclosed in \` and ' symbols in the generated output file. Valid options: `true` or `false`. Default value: `true`

> **Note**: The name of the feature will always be quoted.

#### Define: `sendmail::mc::include`

Add include fragments to the `sendmail.mc` file.

```puppet
sendmail::mc::include { '/etc/mail/m4/clamav-milter.m4': }
```

**Parameters for the `sendmail::mc::include` type:**

##### `filename`

The absolute path of the file to include. Defaults to the resource title.

##### `order`

The position in the `sendmail.mc` file where the include statement will appear. This requires some internal knowledge of the Sendmail module. See the comments in the code of the `sendmail::mc` class for details.

The default value is `59`. This generates the include statements just before the `MAILER` section.

#### Define: `sendmail::mc::ldaproute_domain`

Add a `LDAPROUTE_DOMAIN` macro to the `sendmail.mc` file.

```puppet
sendmail::mc::ldaproute_domain { 'example.net': }
```

**Parameters for the `sendmail::mc::ldaproute_domain` type:**

##### `domain`

The name of the domain for which LDAP routing is enabled. Default value is the resource title.

#### Define: `sendmail::mc::local_config`

Add a `LOCAL_CONFIG` section into the `sendmail.mc` file.

```puppet
sendmail::mc::local_config { 'X-AuthUser':
  content => 'HX-AuthUser: ${auth_authen}',
}
```

**Parameters for the `sendmail::mc::local_config` type:**

##### `content`

The desired contents of the local config section. This attribute is mutually exclusive with `source`.

##### `source`

A source file included as the local config section. This attribute is mutually exclusive with `content`.

#### Define: `sendmail::mc::mailer`

Add a `MAILER` macro to the `sendmail.mc` file.

```puppet
sendmail::mc::mailer { 'local': }
sendmail::mc::mailer { 'smtp': }
```

**Parameters for the `sendmail::mc::mailer` type:**

##### `mailer`

The name of the mailer to add to the configuration. Default is the resource title.

#### Define: `sendmail::mc::masquerade_as`

Add masquerade settings to the `sendmail.mc` file.

```puppet
sendmail::mc::masquerade_as { 'example.com':
  masquerade_envelope => true,
}
```

**Parameters for the `sendmail::mc::masquerade_as` type:**

##### `masquerade_as`

Mail being sent is rewritten as coming from the indicated address. Default is the resource title.

##### `masquerade_domain`

Normally masquerading only rewrites mail from the local host. This parameter sets a set of domain or host names that is used for masquerading. Default value: `[]`

##### `masquerade_domain_file`

The set of domain or host names to be used for masquerading can also be read from the file given here. Default value: `undef`

##### `masquerade_exception`

This parameter can set exceptions if not all hosts or subdomains for a given domain should be rewritten. Default value: `[]`

##### `masquerade_exception_file`

The exceptions can also be read from the file given here. Default value: `undef`

##### `masquerade_envelope`

Normally only header addresses are used for masquerading. By setting this parameter to `true`, also envelope addresses are rewritten. Default value: `false`

##### `allmasquerade`

Enable the `allmasquerade` feature if set to `true`. Default value: `false`

##### `limited_masquerade`

Enable the `limited_masquerade` feature if set to `true`. Default value: `false`

##### `local_no_masquerade`

Enable the `local_no_masquerade` feature if set to `true`. Default value: `false`

##### `masquerade_entire_domain`

Enable the `masquerade_entire_domain` feature if set to `true`. Default value: `false`

##### `exposed_user`

An array of usernames that should not be masqueraded. This may be useful for system users (`root` has been exposed by default prior to Sendmail 8.10). Default value: `[]`

##### `exposed_user_file`

The usernames that should not be masqueraded can also be read from the file given here. Default value: `undef`

#### Define: `sendmail::mc::milter`

Manage Sendmail Milter configuration in `sendmail.mc`.

```puppet
sendmail::mc::milter { 'greylist':
  socket_type => 'local',
  socket_spec => '/var/run/milter-greylist/milter-greylist.sock',
}
```

```puppet
sendmail::mc::milter { 'greylist':
  socket_type => 'inet',
  socket_spec => '12345@127.0.0.1',
}
```

**Parameters for the `sendmail::mc::milter` type:**

##### `socket_type`

The type of socket to use for connecting to the milter. Valid values: `local`, `unix`, `inet`, `inet6`

##### `socket_spec`

The socket specification for connecting to the milter. For the type `local` (`unix` is a synonym) this is the full path to the Unix-domain socket. For the `inet` and `inet6` type socket this must be the port number, a literal `@` character and the host or address specification.

##### `flags`

A single character to specify how milter failures are handled by Sendmail. The letter `R` rejects the message, a `T` causes a temporary failure and the character `4` (available with Sendmail V8.4 or later) rejects with a 421 response code.

##### `send_timeout`

Timeout when sending data from the MTA to the Milter. Default value: `undef` (using the Sendmail default 10sec)

##### `receive_timeout`

Timeout when reading a reply from the Milter. Default value: `undef` (using the Sendmail default 10sec)

##### `eom_timeout`

Overall timeout from sending the messag to Milter until the final end of message reply is received. Default value: `undef` (using the Sendmail default 5min)

##### `connect_timeout`

Connection timeout. Default value: `undef` (using the Sendmail default 5min)

##### `order`

A string used to determine the order of the mail filters in the configuration file. This also defines the order in which the filters are called. Default value: `00`

##### `milter_name`

The name of the milter to create. Defaults to the resource title.

#### Define: `sendmail::mc::modify_mailer_flags`

Add a `MODIFY_MAILER_FLAGS` macro to the `sendmail.mc` file.

```puppet
sendmail::mc::modify_mailer_flags { 'SMTP':
  flags => '+O',
}
```

**Parameters for the `sendmail::mc::modify_mailer_flags` type:**

##### `mailer_name`

The name of the mailer for which the flags will be changed. This name is case-sensitive and must conform to the name of the mailer. Usually this will be a name in uppercase (e.g. `SMTP` or `LOCAL`). Defaults to the resource title.

##### `flags`

The flags to change. Adding single flags is possible by prefixing the flag with a `+` symbol. Removing single flags from the mailer can be done with a `-` symbol as prefix. Without a leading `+` or `-` the flags will replace the flags of the delivery agent.

##### `use_quotes`

A boolean that indicates if the flags should be quoted (using m4 quotes). If this argument is `true`, then the flags will be enclosed in \` and ' symbols in the generated output file. Valid options: `true` or `false`. Default value: `true`

#### Define: `sendmail::mc::ostype`

Add the `OSTYPE` macro to the `sendmail.mc` file.

```puppet
sendmail::mc::ostype { 'Debian': }
```

**Parameters for the `sendmail::mc::ostype` type:**

##### `ostype`

The type of operating system as a string. The value is used to add the `OSTYPE` macro to the generated `sendmail.mc` file. This will include the m4 file with operating system specific settings.

#### Define: `sendmail::mc::trust_auth_mech`

Add the `TRUST_AUTH_MECH` macro to the `sendmail.mc` file.

```puppet
sendmail::mc::trust_auth_mech { 'PLAIN DIGEST-MD5': }
```

```puppet
sendmail::mc::trust_auth_mech { 'trust_auth_mech':
  trust_auth_mech => [ 'PLAIN', 'DIGEST-MD5', ],
}
```

**Parameters for the `sendmail::mc::trust_auth_mech` type:**

##### `trust_auth_mech`

The value of the `TRUST_AUTH_MECH` macro to set. If this is a string it is used as-is. For an array the value will be concatenated into a string. Default is the resource title.

#### Define: `sendmail::mc::versionid`

Add the `VERSIONID` macro to the `sendmail.mc` file.

```puppet
sendmail::mc::versionid { 'generic': }
```

**Parameters for the `sendmail::mc::versionid` type:**

##### `versionid`

The identifier (a string) to set in the `sendmail.mc` file.

### Augeas Lenses

#### Augeas Lens: `sendmail_map`

The Sendmail module contains the Augeas lens `sendmail_map`. This lens has been built to easily manage entries in various Sendmail files (e.g. `mailertable`, `access`, ...). The lens is used by the provided module classes and so there should not be any need to call this lens directly.

### Templates

The Sendmail module uses templates to build the `sendmail.mc` and `submit.mc` files. These are not meant for user configuration.

## Limitations

The Sendmail module is currently developed and tested on:
* Debian 7 (Wheezy)
* Debian 8 (Jessie)
* FreeBSD 10

More supported operating systems are planned in future releases.

## Development

Sendmail is a powerful tool with many configuration options. The module includes configuration options I considered useful or needed for my own environment.

You may open Github issues for this module if you need additional configuration file options currently not available.

Feel free to send pull requests for new features.
