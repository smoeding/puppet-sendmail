# = Class: sendmail::aliases::file
#
# Create the Sendmail aliases file.
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
#   class { 'sendmail::aliases::file': }
#
#
class sendmail::aliases::file (
  $content = undef,
  $source  = undef,
){
  include ::sendmail::params
  include ::sendmail::aliases::newaliases

  file { $::sendmail::params::alias_file:
    ensure  => file,
    content => $content,
    source  => $source,
    owner   => 'root',
    group   => $::sendmail::params::alias_file_group,
    mode    => '0644',
    notify  => Class['::sendmail::aliases::newaliases'],
  }
}
