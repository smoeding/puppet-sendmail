# = Class: sendmail::domaintable::file
#
# Create the Sendmail domaintable db file.
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
#   class { 'sendmail::domaintable::file': }
#
#
class sendmail::domaintable::file {
  include ::sendmail::params

  file { $::sendmail::params::domaintable_file:
    ensure => file,
    owner  => 'smmta',
    group  => $::sendmail::params::sendmail_group,
    mode   => '0640',
  }
}
