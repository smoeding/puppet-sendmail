# = Class: sendmail::files::relaydomains
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
#   class { 'sendmail::files::relaydomains': }
#
#
class sendmail::files::relaydomains {
  include ::sendmail::params

  file { '/etc/mail/relay-domains':
    ensure => file,
    owner  => 'root',
    group  => 'smmsp',
    mode   => '0644',
  }
}
