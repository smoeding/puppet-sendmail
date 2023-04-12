# @summary Manage the Sendmail virtusertable db file.
#
# @example
#   class { 'sendmail::virtusertable::file': }
#
# @param content The content of the file resource.
#
# @param source The source of the file resource.
#
#
class sendmail::virtusertable::file (
  Optional[String] $content = undef,
  Optional[String] $source  = undef,
) {
  include sendmail::params
  include sendmail::makeall

  file { $sendmail::params::virtusertable_file:
    ensure  => file,
    content => $content,
    source  => $source,
    owner   => $sendmail::params::sendmail_user,
    group   => $sendmail::params::sendmail_group,
    mode    => '0640',
    notify  => Class['sendmail::makeall'],
  }
}
