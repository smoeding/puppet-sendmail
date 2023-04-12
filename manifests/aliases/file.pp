# @summary Create the Sendmail aliases file.
#
# @example
#   class { 'sendmail::aliases::file': }
#
# @param content The content of the file resource.
#
# @param source The source of the file resource.
#
#
class sendmail::aliases::file (
  Optional[String] $content = undef,
  Optional[String] $source  = undef,
){
  include sendmail::params
  include sendmail::aliases::newaliases

  file { $sendmail::params::alias_file:
    ensure  => file,
    content => $content,
    source  => $source,
    owner   => 'root',
    group   => $sendmail::params::alias_file_group,
    mode    => '0644',
    notify  => Class['sendmail::aliases::newaliases'],
  }
}
