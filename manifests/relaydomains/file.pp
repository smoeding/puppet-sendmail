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

  file { '/etc/mail/relay-domains':
    ensure => file,
    owner  => 'root',
    group  => 'smmsp',
    mode   => '0644',
  }
}
