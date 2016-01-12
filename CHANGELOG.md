## UNRELEASED

### Summary

This release fixes a bug that can lead to an aborted Puppet run when a STARTTLS configuration is deployed to a machine where Sendmail is not yet installed. It also includes some minor new features.

#### Features

- Add `max_message_size` as parameter in the `sendmail` and `sendmail::nullclient` classes.
- Rename daemon in nullcient setup from `MTA` to `MSA`.

#### Bugfixes

- Improve handling of an undefined `$::sendmail_version` fact. Puppet collects all facts before the agent starts to manage any resources. Calling the `sendmail` binary to extract the version number therefore returns an undefined value if Sendmail is not yet installed. So in some cases Puppet may need to run twice before the desired configuration is complete.

## 2015-12-28 - Release 0.1.0

### Summary

Initial release.
