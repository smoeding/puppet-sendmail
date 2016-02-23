# = Class: sendmail::authinfo::file
#
# Create the Sendmail authinfo db file.
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
#   class { 'sendmail::authinfo::file': }
#
#
class sendmail::authinfo::file (
  $content = undef,
  $source  = undef,
) {
  include ::sendmail::params
  include ::sendmail::makeall

  file { $::sendmail::params::authinfo_file:
    ensure  => file,
    content => $content,
    source  => $source,
    owner   => 'root',
    group   => $::sendmail::params::sendmail_group,
    mode    => '0600',
    notify  => Class['::sendmail::makeall'],
  }
}
