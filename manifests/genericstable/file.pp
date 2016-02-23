# = Class: sendmail::genericstable::file
#
# Manage the Sendmail genericstable db file.
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
#   class { 'sendmail::genericstable::file': }
#
#
class sendmail::genericstable::file (
  $content = undef,
  $source  = undef,
) {
  include ::sendmail::params
  include ::sendmail::makeall

  file { $::sendmail::params::genericstable_file:
    ensure  => file,
    content => $content,
    source  => $source,
    owner   => $::sendmail::params::sendmail_user,
    group   => $::sendmail::params::sendmail_group,
    mode    => '0640',
    notify  => Class['::sendmail::makeall'],
  }
}
