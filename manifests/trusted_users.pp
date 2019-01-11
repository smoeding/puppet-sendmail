# = Class: sendmail::trusted_users
#
# Manage entries in the Sendmail trusted-users file.
#
# == Parameters:
#
# [*trusted_users*]
#   An array of user names that will be written into the trusted users file.
#   Leading or trailing whitespace is ignored. Empty entries are also
#   ignored. Default value: []
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'sendmail::trusted_users':
#     trusted_users => [ 'root', 'fred', ],
#   }
#
#
class sendmail::trusted_users (
  Array[String] $trusted_users = [],
) {
  include sendmail::params

  file { $::sendmail::params::trusted_users_file:
    ensure  => file,
    owner   => 'root',
    group   => $::sendmail::params::sendmail_group,
    mode    => '0644',
    content => join(suffix(sendmail::canonify_array($trusted_users), "\n")),
    notify  => Class['sendmail::service'],
  }
}
