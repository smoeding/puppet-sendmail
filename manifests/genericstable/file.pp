# = Class: sendmail::genericstable::file
#
# Create the Sendmail genericstable db file.
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
#   class { 'sendmail::genericstable::file': }
#
#
class sendmail::genericstable::file {
  include ::sendmail::params

  file { $::sendmail::params::genericstable_file:
    ensure => file,
    owner  => 'smmta',
    group  => $::sendmail::params::sendmail_group,
    mode   => '0640',
  }
}
