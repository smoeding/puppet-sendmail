# @summary Manage an entry in the Sendmail userdb file.
#
# The type has an internal dependency to rebuild the database file.
#
# @example Add an entry to the userdb
#   sendmail::userdb::entry { 'fred:maildrop':
#     value => 'fred@example.org',
#   }
#
# @param ensure Used to create or remove the userdb db entry.  Valid options:
#   `present`, `absent`.
#
# @param key The key used by Sendmail for the lookup.  This normally is in
#   the format `user:maildrop` or `user:mailname` where user is the a local
#   username.
#
# @param value The value for the given key.  For the userdb map this is
#   typically a single mailaddress or a compound list of addresses separated
#   by commas.
#
#
define sendmail::userdb::entry (
  Enum['present','absent'] $ensure = 'present',
  String                   $key    = $title,
  Optional[String]         $value  = undef,
) {
  include sendmail::params
  include sendmail::makeall
  include sendmail::userdb::file

  if ($ensure == 'present' and empty($value)) {
    fail('value must be set when creating an userdb entry')
  }

  $changes = $ensure ? {
    'present' => [
      "set key[. = '${key}'] '${key}'",
      "set key[. = '${key}']/value '${value}'",
    ],
    'absent'  => "rm key[ . = '${key}']",
  }

  augeas { "${::sendmail::params::userdb_file}-${title}":
    lens    => 'Sendmail_Map.lns',
    incl    => $::sendmail::params::userdb_file,
    changes => $changes,
    require => Class['sendmail::userdb::file'],
    notify  => Class['sendmail::makeall'],
  }
}
