# @summary Manage an entry in the Sendmail domaintable file.
#
# @example Add an entry to the domaintable
#   sendmail::domaintable::entry { 'example.com':
#     value => 'example.org',
#   }
#
# @param ensure Used to create or remove the domaintable db entry.  Valid
#   options: `present`, `absent`.
#
# @param key The key used by Sendmail for the lookup.  This should normally
#   be a domain name.
#
# @param value The value for the given key.  For the domaintable map this is
#   typically another domain name.
#
#
define sendmail::domaintable::entry (
  Enum['present','absent'] $ensure = 'present',
  String                   $key    = $title,
  Optional[String]         $value  = undef,
) {
  include sendmail::params
  include sendmail::makeall
  include sendmail::domaintable::file

  if ($ensure == 'present' and empty($value)) {
    fail('value must be set when creating a domaintable entry')
  }

  $changes = $ensure ? {
    'present' => [
      "set key[. = '${key}'] '${key}'",
      "set key[. = '${key}']/value '${value}'",
    ],
    'absent'  => "rm key[ . = '${key}']",
  }

  augeas { "${::sendmail::params::domaintable_file}-${title}":
    lens    => 'Sendmail_Map.lns',
    incl    => $::sendmail::params::domaintable_file,
    changes => $changes,
    require => Class['sendmail::domaintable::file'],
    notify  => Class['sendmail::makeall'],
  }
}
