# = Class: sendmail::localhostnames::file
#
# Create the Sendmail local-host-names file.
#
# == Parameters:
#
# None.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'sendmail::localhostnames::file': }
#
#
class sendmail::localhostnames::file {
  include ::sendmail::params

  file { $::sendmail::params::localhostnames_file:
    ensure => file,
    owner  => 'root',
    group  => $::sendmail::params::sendmail_group,
    mode   => '0644',
  }
}
