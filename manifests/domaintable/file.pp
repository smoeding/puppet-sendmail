# @summary Manage the Sendmail domaintable db file.
#
# @example
#   class { 'sendmail::domaintable::file': }
#
# @param content The content of the file resource.
#
# @param source The source of the file resource.
#
#
class sendmail::domaintable::file (
  Optional[String] $content = undef,
  Optional[String] $source  = undef,
) {
  include sendmail::params
  include sendmail::makeall

  file { $::sendmail::params::domaintable_file:
    ensure  => file,
    content => $content,
    source  => $source,
    owner   => $::sendmail::params::sendmail_user,
    group   => $::sendmail::params::sendmail_group,
    mode    => '0640',
    notify  => Class['sendmail::makeall'],
  }
}
