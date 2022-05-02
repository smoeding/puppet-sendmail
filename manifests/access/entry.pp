# @summary Manage an entry in the Sendmail access db file.
#
# The feature `access_db` must also be enabled by calling
# `sendmail::mc::feature` to make Sendmail use the access db file.
#
# @example Create an access entry for a domain
#   sendmail::access::entry { 'example.com':
#     value => 'RELAY',
#   }
#
# @param ensure Used to create or remove the access db entry.  Valid options:
#   `present`, `absent`.
#
# @param key The key used by Sendmail for the lookup.  This could for example
#   be a domain name.
#
# @param value The value for the given key.  For the access map this is
#   typically something like `OK`, `REJECT` or `DISCARD`.
#
#
define sendmail::access::entry (
  Enum['present','absent'] $ensure = 'present',
  String                   $key    = $name,
  Optional[String]         $value  = undef,
) {
  include sendmail::params
  include sendmail::makeall
  include sendmail::access::file

  if ($ensure == 'present' and empty($value)) {
    fail('value must be set when creating an access entry')
  }

  $changes = $ensure ? {
    'present' => [
      "set key[. = '${key}'] '${key}'",
      "set key[. = '${key}']/value '${value}'",
    ],
    'absent'  => "rm key[ . = '${key}']",
  }

  augeas { "${::sendmail::params::access_file}-${title}":
    lens    => 'Sendmail_Map.lns',
    incl    => $::sendmail::params::access_file,
    changes => $changes,
    require => Class['sendmail::access::file'],
    notify  => Class['sendmail::makeall'],
  }
}
