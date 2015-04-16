# = Class: sendmail::userdb::file
#
# Create the Sendmail userdb db file.
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
#   class { 'sendmail::userdb::file': }
#
#
class sendmail::userdb::file {
  include ::sendmail::params

  file { $::sendmail::params::userdb_file:
    ensure => file,
    owner  => 'smmta',
    group  => $::sendmail::params::sendmail_group,
    mode   => '0640',
  }
}
