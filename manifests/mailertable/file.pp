# @summary Manage the Sendmail mailertable db file.
#
# @example
#   class { 'sendmail::mailertable::file': }
#
# @param content The content of the file resource.
#
# @param source The source of the file resource.
#
#
class sendmail::mailertable::file (
  Optional[String] $content = undef,
  Optional[String] $source  = undef,
) {
  include sendmail::params
  include sendmail::makeall

  file { $::sendmail::params::mailertable_file:
    ensure  => file,
    content => $content,
    source  => $source,
    owner   => $::sendmail::params::sendmail_user,
    group   => $::sendmail::params::sendmail_group,
    mode    => '0644',
    notify  => Class['sendmail::makeall'],
  }
}
