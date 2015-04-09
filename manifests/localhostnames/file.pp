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

  file { '/etc/mail/local-host-names':
    ensure => file,
    owner  => 'root',
    group  => 'smmsp',
    mode   => '0644',
  }
}
