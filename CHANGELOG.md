## 2016-09-10 - Release 1.0.0

### Summary

With this 1.0.0 release the module interface is considered stable. The requirements have been updated to Puppet 3.7 or Puppet Enterprise 3.7.

#### Features

- Add Ubuntu 16.04 (Xenial Xerus) to the list of supported operating systems.

#### Bugfixes

- A timeout for the sendmail version fact has been added (fixes #10).

## 2016-04-27 - Release 0.7.0

### Summary

A small release that fixes a metadata warning and introduces the `domain_name` parameter.

#### Features

- Add parameter `domain_name` to allow setting the fully qualified domain name that Sendmail should use. This may be useful in rare conditions where Sendmail runs on a multihomed machine and picks the wrong name.

#### Bugfixes

- Update metadate dependencies to use a dash instead of a slash character. This fixes a dependency warning on newer Puppet releases.

## 2016-04-10 - Release 0.6.1

### Summary

This release contains the fix for a problem with the group ownership of the aliases file on FreeBSD. Also some internal tests were rewritten to use the rspec-puppet-facts gem.

#### Bugfixes

- Fix group ownership of aliases file on FreeBSD.

## 2016-03-25 - Release 0.6.0

### Summary

This release adds FreeBSD compatibility. It also adds a new class to configure Sendmail related timeouts in a single place.

#### Features

- Add FreeBSD 10  to the list of supported operating systems.
- Add class `sendmail::mc::timeouts` to conveniently specify most of the timeouts in one place.
- The class `sendmail::privacy_flags` has been renamed to `sendmail::mc::privacy_flags`.

#### Bugfixes

- The `mailx` package is no longer managed by the Sendmail module. The user should be free to decide which MUA to install.

## 2016-02-23 - Release 0.5.0

### Summary

The release fixes some bugs. It has also been verified to run on Ubuntu 15.10.

#### Features

- Add Ubuntu 15.10 (Wily Werewolf) to the list of supported operating systems.

#### Bugfixes

- Fix intermittent change of parameter order in some cases.
- Fix file owner and group on RedHat family.
- Fix errors in logfile when `/usr/sbin/sendmail` isn't really Sendmail.

## 2016-02-11 - Release 0.4.0

### Summary

This release contains some enhancements. See the following items for details.

#### Features

- Add configuration parameters `enable_ipv4_msa` and `enable_ipv6_msa` to the `sendmail::nullclient` class to configure the MSA for IPv4 and IPv6.
- Define privacy flags for the daemon with the help of the `sendmail::privacy_flags` class.
- Add parameter `daemon_name` to the `sendmail::mc::daemon_options` type. This allows reusing the same name for multiple daemon option enties.
- Allow a string parameter for `sendmail::mc::feature` if the feature requires only a single argument.

## 2016-01-21 - Release 0.3.0

### Summary

This release adds support for the RedHat family and also includes some minor new features.

#### Features

- Add RedHat/CentOS 6/7 to the list of supported operating systems.
- New parameter `enable_msp_trusted_users` to activate the `use_ct_file` feature in `submit.mc`.
- Allow strings and arrays for the `input_milter` parameter of the `sendmail::mc::daemon_options` defined type.

#### Bugfixes

- The nullclient setup didn't allow setting the content of the trusted users file. This has been fix by adding the `trusted_users` parameter to the `sendmail::nullclient` class.

## 2016-01-14 - Release 0.2.0

### Summary

This release fixes a bug that can lead to an aborted Puppet run when a STARTTLS configuration is deployed to a machine where Sendmail is not yet installed. It also includes support for Ubuntu and some minor new features.

#### Features

- Add Ubuntu 14.04 (Trusty Tahr) and 15.04 (Vivid Vervet) to the list of supported operating systems.
- Improvement and documentation of the `sendmail::authinfo::entry` defined type.
- Add parameter `max_message_size` for the `sendmail` and `sendmail::nullclient` classes.
- Rename daemon in nullcient setup from `MTA` to `MSA`.

#### Bugfixes

- Improve handling of an undefined `$::sendmail_version` fact. Using this fact returns an undefined value if Sendmail is not yet installed. For some configurations Puppet may need to run twice before the desired configuration is reached.

## 2015-12-28 - Release 0.1.0

### Summary

Initial release.
