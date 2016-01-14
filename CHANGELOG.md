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
