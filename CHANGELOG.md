## UNRELEASED

### Summary

TODO

#### Features

- Add parameters to allow simple masquerading with the `sendmail::nullclient` class.

#### Bugfixes

- Improve handling of an undefined `$::sendmail_version` fact. Puppet collects all facts before the agent starts to manage any resources. Calling the `sendmail` binary to extract the version number therefore returns an undefined value if Sendmail is not yet installed. So in some cases Puppet may need to run twice before the desired configuration is complete.

## 2015-12-28 - Release 0.1.0

### Summary

Initial release.
