# = Class: sendmail::relaydomain::create
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
#   class { 'sendmail::relaydomain::create': }
#
#
class sendmail::relaydomain::create {
  include ::sendmail::params

  file { '/etc/mail/relay-domains':
    ensure => file,
    owner  => 'root',
    group  => 'smmsp',
    mode   => '0644',
  }
}
