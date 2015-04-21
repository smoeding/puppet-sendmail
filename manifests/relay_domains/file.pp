# = Class: sendmail::relay_domains::file
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
#   class { 'sendmail::relay_domains::file': }
#
#
class sendmail::relay_domains::file {
  include ::sendmail::params

  file { $::sendmail::params::relay_domains_file:
    ensure => file,
    owner  => 'root',
    group  => $::sendmail::params::sendmail_group,
    mode   => '0644',
  }
}
