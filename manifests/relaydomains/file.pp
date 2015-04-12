# = Class: sendmail::relaydomains::file
#
# Create the Sendmail relay-domains file.
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
#   class { 'sendmail::relaydomains::file': }
#
#
class sendmail::relaydomains::file {
  include ::sendmail::params

  file { $::sendmail::params::relaydomains_file:
    ensure => file,
    owner  => 'root',
    group  => $::sendmail::params::sendmail_group,
    mode   => '0644',
  }
}
