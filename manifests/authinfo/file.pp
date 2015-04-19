# = Class: sendmail::authinfo::file
#
# Create the Sendmail authinfo db file.
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
#   class { 'sendmail::authinfo::file': }
#
#
class sendmail::authinfo::file {
  include ::sendmail::params

  file { $::sendmail::params::authinfo_file:
    ensure => file,
    owner  => 'root',
    group  => $::sendmail::params::sendmail_group,
    mode   => '0640',
  }
}
