# = Class: sendmail::access::file
#
# Create the Sendmail access db file.
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
#   class { 'sendmail::access::file': }
#
#
class sendmail::access::file {
  include ::sendmail::params

  file { $::sendmail::params::access_file:
    ensure => file,
    owner  => 'smmta',
    group  => $::sendmail::params::sendmail_group,
    mode   => '0640',
  }
}
