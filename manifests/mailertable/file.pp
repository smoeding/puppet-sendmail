# = Class: sendmail::mailertable::file
#
# Create the Sendmail mailertable db file.
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
#   class { 'sendmail::mailertable::file': }
#
#
class sendmail::mailertable::file {
  include ::sendmail::params

  file { $::sendmail::params::mailertable_file:
    ensure => file,
    owner  => 'smmta',
    group  => $::sendmail::params::sendmail_group,
    mode   => '0644',
  }
}
