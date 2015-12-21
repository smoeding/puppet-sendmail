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

The sendmail module uses a custom Augeas lense so the Puppet configuration setting `pluginsync` must be enabled. It also requires the Puppetlabs modules `stdlib` and `concat`.

### Beginning with Sendmail

Declare the Sendmail class to install and run Sendmail with the default parameters.

```puppet
class { 'sendmail': }
```

This installs the necessary packages and starts the Sendmail service. With this setup Sendmail will send messages to other hosts and also accept mail for the local host.

Sendmail has a lot of configuration knobs and a complete setup may need more than just a few parameters. So it is probably a good idea to encapsulate your Sendmail settings by using the roles and profiles pattern.

See the next sections for a detailed description of the available configuration options.

## Usage

The Sendmail module provides classes and defined types to individually manage many of the configuration parameters used in the `sendmail.mc` file. This offers the possibility to manage even complex and unusual configurations with Puppet. The main Sendmail class also has parameters to directly enable certain configuration items without the need to provide a complete user defined `sendmail.mc` configuration.

### I have a working config and like to keep it

Disable the internal management of the sendmail configuration files by setting the parameters [`manage_sendmail_mc`](#manage_sendmail_mc) or [`manage_submit_mc`](#manage_submit_mc) to `false`:

```puppet
class { 'sendmail':
  manage_sendmail_mc => false,
  manage_submit_mc   => false,
}
```

**Note**: These settings also disable the automatic generation of the `sendmail.cf` and `submit.cf` files. You will have to do that yourself if you change one of the files.

### I am behind a firewall and need to forward outgoing mail to a relay host

Use the [`smart_host`](#smart_host) parameter to set the host where all outgoing mail should be forwarded to.

```puppet
class { 'sendmail':
  smart_host => 'relay.example.com',
}
```

### I have a host that should not receive any mail

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
  ca_cert_file     => '/etc/mail/tls/CA.pem',
  server_cert_file => '/etc/mail/tls/server.pem',
  server_key_file  => '/etc/mail/tls/server.key',
  client_cert_file => '/etc/mail/tls/client.pem',
  client_key_file  => '/etc/mail/tls/client.key',
  dh_params        => '2048',
}
```

**Note**: The Sendmail module does not manage any x509 certificates or key files.

## Reference

- [**Public Classes**](#public-classes)
  - [Class: sendmail](#class-sendmail)
  - [Class: sendmail::aliases](#class-sendmailaliases)
  - [Class: sendmail::access](#class-sendmailaccess)
  - [Class: sendmail::domaintable](#class-sendmaildomaintable)
  - [Class: sendmail::genericstable](#class-sendmailgenericstable)
  - [Class: sendmail::mailertable](#class-sendmailmailertable)
  - [Class: sendmail::userdb](#class-sendmailuserdb)
  - [Class: sendmail::virtusertable](#class-sendmailvirtusertable)
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
  - [Classes: sendmail::*::file](#classes-sendmailfile)
  - [Classes: sendmail::mc::*_section](#classes-sendmailmc_section)
- [**Public Defined Types**](#public-defined-types)
  - [Define: sendmail::aliases::entry](#define-sendmailaliasesentry)
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
  - [Define: sendmail::mc::local_config](#define-sendmailmclocal_config)
  - [Define: sendmail::mc::mailer](#define-sendmailmcmailer)
  - [Define: sendmail::mc::modify_mailer_flags](#define-sendmailmcmodify_mailer_flags)
  - [Define: sendmail::mc::ostype](#define-sendmailmcostype)
  - [Define: sendmail::mc::starttls](#define-sendmailmcstarttls)
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

A hash that will be used to create [`sendmail::aliases::entry`](#define-sendmailaliasesentry) resources. Default value: `{}`

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

#### Class: `sendmail::aliases`

Manage the Sendmail aliases file. The class manages the file either as a single file resource or each entry in the file separately.

The file is managed as a whole using the `source` or `content` parameters.

```puppet
class { sendmail::aliases':
  source => 'puppet:///modules/site/aliases',
}
```

The `entries` parameter is used to manage each entry separately. Preferable this is done with hiera using automatic parameter lookup.

```puppet
class { sendmail::aliases': }
```

**Parameters for the `sendmail::aliases` class:**

##### `content`

The desired contents of the aliases file. This allows managing the aliases file as a whole. Changes to the file automatically triggers a rebuild of the aliases database file. This attribute is mutually exclusive with `source`.

##### `source`

A source file for the aliases file. This allows managing the aliases file as a whole. Changes to the file automatically triggers a rebuild of the aliases database file. This attribute is mutually exclusive with `content`.

##### `entries`

A hash that will be used to create [`sendmail::aliases::entry`](#define-sendmailaliasesentry) resources. The class can be used to create aliases defined in hiera. The hiera hash should look like this:

```yaml
sendmail::aliases::entries:
  'fred':
	recipient: 'barney@example.org'
```

#### Class: `sendmail::access`

Manage the Sendmail access db file. The class manages the file either as a single file resource or each entry in the file separately.

The file is managed as a whole using the `source` or `content` parameters.

```puppet
class { sendmail::access':
  source => 'puppet:///modules/site/access',
}
```

The `entries` parameter is used to manage each entry separately. Preferable this is done with hiera using automatic parameter lookup.

```puppet
class { sendmail::access': }
```

**Parameters for the `sendmail::access` class:**

##### `content`

The desired contents of the access file. This allows managing the access file as a whole. Changes to the file automatically triggers a rebuild of the access database file. This attribute is mutually exclusive with `source`.

##### `source`

A source file for the access file. This allows managing the access file as a whole. Changes to the file automatically triggers a rebuild of the access database file. This attribute is mutually exclusive with `content`.

##### `entries`

A hash that will be used to create [`sendmail::access::entry`](#define-sendmailaccessentry) resources. The class can be used to create access entries defined in hiera. The hiera hash should look like this:

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
class { sendmail::domaintable':
  source => 'puppet:///modules/site/domaintable,
}
```

The `entries` parameter is used to manage each entry separately. Preferable this is done with hiera using automatic parameter lookup.

```puppet
class { sendmail::domaintable': }
```

**Parameters for the `sendmail::domaintable` class:**

##### `content`

The desired contents of the domaintable file. This allows managing the domaintable file as a whole. Changes to the file automatically triggers a rebuild of the domaintable database file. This attribute is mutually exclusive with `source`.

##### `source`

A source file for the domaintable file. This allows managing the domaintable file as a whole. Changes to the file automatically triggers a rebuild of the domaintable database file. This attribute is mutually exclusive with `content`.

##### `entries`

A hash that will be used to create [`sendmail::domaintable::entry`](#define-sendmaildomaintableentry) resources. This class can be used to create domaintable entries defined in hiera. The hiera hash should look like this:

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
class { sendmail::genericstable':
  source => 'puppet:///modules/site/genericstable',
}
```

The `entries` parameter is used to manage each entry separately. Preferable this is done with hiera using automatic parameter lookup.

```puppet
class { sendmail::genericstable': }
```

**Parameters for the `sendmail::genericstable` class:**

##### `content`

The desired contents of the genericstable file. This allows managing the genericstable file as a whole. Changes to the file automatically triggers a rebuild of the genericstable database file. This attribute is mutually exclusive with `source`.

##### `source`

A source file for the genericstable file. This allows managing the genericstable file as a whole. Changes to the file automatically triggers a rebuild of the genericstable database file. This attribute is mutually exclusive with `content`.

##### `entries`

A hash that will be used to create [`sendmail::genericstable::entry`](#define-sendmailgenericstableentry) resources. This class can be used to create genericstable entries defined in hiera. The hiera hash should look like this:

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
class { sendmail::mailertable':
  source => 'puppet:///modules/site/mailertable',
}
```

The `entries` parameter is used to manage each entry separately. Preferable this is done with hiera using automatic parameter lookup.

```puppet
class { sendmail::mailertable': }
```

**Parameters for the `sendmail::mailertable` class:**

##### `content`

The desired contents of the mailertable file. This allows managing the mailertable file as a whole. Changes to the file automatically triggers a rebuild of the mailertable database file. This attribute is mutually exclusive with `source`.

##### `source`

A source file for the mailertable file. This allows managing the mailertable file as a whole. Changes to the file automatically triggers a rebuild of the mailertable database file. This attribute is mutually exclusive with `content`.

##### `entries`

A hash that will be used to create [`sendmail::mailertable::entry`](#define-sendmailmailertableentry) resources. This class can be used to create mailertable entries defined in hiera. The hiera hash should look like this:

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
class { sendmail::userdb':
  source => 'puppet:///modules/site/userdb',
}
```

The `entries` parameter is used to manage each entry separately. Preferable this is done with hiera using automatic parameter lookup.

```puppet
class { sendmail::userdb': }
```

**Parameters for the `sendmail::userdb` class:**

##### `content`

The desired contents of the userdb file. This allows managing the userdb file as a whole. Changes to the file automatically triggers a rebuild of the userdb database file. This attribute is mutually exclusive with `source`.

##### `source`

A source file for the userdb file. This allows managing the userdb file as a whole. Changes to the file automatically triggers a rebuild of the userdb database file. This attribute is mutually exclusive with `content`.

##### `entries`

A hash that will be used to create [`sendmail::userdb::entry`](#define-sendmailuserdbentry) resources. This class can be used to create userdb entries defined in hiera. The hiera hash should look like this:

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
class { sendmail::virtusertable':
  source => 'puppet:///modules/site/virtusertable',
}
```

The `entries` parameter is used to manage each entry separately. Preferable this is done with hiera using automatic parameter lookup.

```puppet
class { sendmail::virtusertable': }
```

**Parameters for the `sendmail::virtusertable` class:**

##### `content`

The desired contents of the virtusertable file. This allows managing the virtusertable file as a whole. Changes to the file automatically triggers a rebuild of the virtusertable database file. This attribute is mutually exclusive with `source`.

##### `source`

A source file for the virtusertable file. This allows managing the virtusertable file as a whole. Changes to the file automatically triggers a rebuild of the virtusertable database file. This attribute is mutually exclusive with `content`.

##### `entries`

A hash that will be used to create [`sendmail::virtusertable::entry`](#define-sendmailvirtusertableentry) resources. This class can be used to create virtusertable entries defined in hiera. The hiera hash should look like this:

```yaml
sendmail::virtusertable::entries:
  'info@example.com':
	value: 'fred'
  '@example.org':
	value: 'barney'
```

### Private Classes

#### Class: `sendmail::mc`

Manage the `sendmail.mc` file. This class uses the `concat` module to create configuration fragments to assemble the final configuration file.

#### Class: `sendmail::submit`

Manage the `submit.mc` file that contains the configuration for the local message submission program.

#### Class: `sendmail::local_host_names`

Manage entries in the Sendmail local-host-names file. Do not declare this class directly. Use the [`local_host_names`](#local_host_names) parameter of the [`sendmail`](#class-sendmail) class instead.

```puppet
class { 'sendmail::local_host_names:
  local_host_names => [ 'example.org', 'mail.example.org', ],
}
```

**Parameters for the `sendmail::local_host_names` class:**

##### `local_host_names`

An array of host names that will be written into the local host names file. Leading or trailing whitespace is ignored. Empty entries are also ignored. Default value: `[]`

#### Class: `sendmail::relay_domains`

Manage entries in the Sendmail relay-domains file. Do not declare this class directly. Use the [`relay_domains`](#relay_domains) parameter of the [`sendmail`](#class-sendmail) class instead.

```puppet
class { 'sendmail::relay_domains':
  relay_domains => [ 'example.com', 'example.net', ],
}
```

**Parameters for the `sendmail::relay_domains` class:**

##### `relay_domains`

An array of domain names that will be written into the relay domains file. Leading or trailing whitespace is ignored. Empty entries are also ignored. Default value: `[]`

#### Class: `sendmail::trusted_users`

Manage entries in the Sendmail trusted-users file. Do not declare this class directly. Use the [`trusted_users`](#trusted_users) parameter of the [`sendmail`](#class-sendmail) class instead.

```puppet
class { 'sendmail::trusted_users':
  trusted_users => [ 'root', 'fred', ],
}
```

**Parameters for the `sendmail::trusted_users` class:**

##### `trusted_users`

An array of user names that will be written into the trusted users file. Leading or trailing whitespace is ignored. Empty entries are also ignored. Default value: `[]`

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

#### Classes: `sendmail::*::file`

These classes manage the various Sendmail database files and ensure correct owner, group and permissions.

#### Classes: `sendmail::mc::*_section`

These classes are included by some of the `sendmail::mc::*` defined types to create a suitable section header in the generated `sendmail.mc` file. The sole purpose is to improve the readability of the file.

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

Used to create or remove the alias entry. Valid options: `present`, `absent`. Default: `present`

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

Used to create or remove the access db entry. Valid options: `present`, `absent`. Default: `present`

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

Used to create or remove the domaintable db entry. Valid options: `present`, `absent`. Default: `present`

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

Used to create or remove the genericstable db entry. Valid options: `present`, `absent`. Default: `present`

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

Used to create or remove the mailertable db entry. Valid options: `present`, `absent`. Default: `present`

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

Used to create or remove the userdb db entry. Valid options: `present`, `absent`. Default: `present`

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

Used to create or remove the virtusertable db entry. Valid options: `present`, `absent`. Default: `present`

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

The Sendmail module contains the Augeas lens `sendmail_map`. This lens has been built to easily manage entries in various Sendmail files (e.g. `mailertable`, `access`, ...). The lens is used by the provided module classes and so there should not be any need to call this lens directly.

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
