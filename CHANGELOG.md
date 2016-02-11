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
