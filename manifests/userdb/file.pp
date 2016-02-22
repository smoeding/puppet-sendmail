# = Class: sendmail::userdb::file
#
# Manage the Sendmail userdb db file.
#
# == Parameters:
#
# [*content*]
#   The content of the file resource.
#
# [*source*]
#   The source of the file resource.
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
class sendmail::userdb::file (
  $content = undef,
  $source  = undef,
) {
  include ::sendmail::params
  include ::sendmail::makeall

  file { $::sendmail::params::userdb_file:
    ensure  => file,
    content => $content,
    source  => $source,
    owner   => $::sendmail::params::sendmail_user,
    group   => $::sendmail::params::sendmail_group,
    mode    => '0640',
    notify  => Class['::sendmail::makeall'],
  }
}
