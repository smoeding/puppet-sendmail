# @summary Create the Sendmail authinfo db file.
#
# @example
#   class { 'sendmail::authinfo::file': }
#
# @param content The content of the file resource.
#
# @param source The source of the file resource.
#
#
class sendmail::authinfo::file (
  Optional[String] $content = undef,
  Optional[String] $source  = undef,
) {
  include sendmail::params
  include sendmail::makeall

  file { $::sendmail::params::authinfo_file:
    ensure  => file,
    content => $content,
    source  => $source,
    owner   => 'root',
    group   => $::sendmail::params::sendmail_group,
    mode    => '0600',
    notify  => Class['sendmail::makeall'],
  }
}
