# = Class: sendmail::virtusertable::file
#
# Create the Sendmail virtusertable db file.
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
#   class { 'sendmail::virtusertable::file': }
#
#
class sendmail::virtusertable::file {
  include ::sendmail::params

  file { $::sendmail::params::virtusertable_file:
    ensure => file,
    owner  => 'smmta',
    group  => $::sendmail::params::sendmail_group,
    mode   => '0640',
  }
}
