# = Class: sendmail::local_host_names::file
#
# Create the Sendmail local-host-names file.
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
#   class { 'sendmail::local_host_names::file': }
#
#
class sendmail::local_host_names::file {
  include ::sendmail::params

  file { $::sendmail::params::local_host_names_file:
    ensure => file,
    owner  => 'root',
    group  => $::sendmail::params::sendmail_group,
    mode   => '0644',
  }
}
