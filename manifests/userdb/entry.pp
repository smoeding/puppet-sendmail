# = Define: sendmail::userdb::entry
#
# Create entries in the Sendmail userdb db file.
#
# == Parameters:
#
# [*value*]
#   The value for the given key. For the userdb map this is typically
#   a single mailaddress or a compound list of addresses separated
#   by commas.
#
# [*key*]
#   The key used by Sendmail for the lookup. This normally is in the format
#   user:maildrop or user:mailname where user is the a local username.
#
# [*ensure*]
#   Used to create or remove the userdb db entry.
#   Default: present
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::userdb::entry { 'fred:maildrop':
#     value => 'fred@example.org',
#   }
#
#
define sendmail::userdb::entry (
  $value  = undef,
  $key    = $name,
  $ensure = present,
) {
  include ::sendmail::params
  include ::sendmail::makeall
  include ::sendmail::userdb::file

  if ($ensure == present and empty($value)) {
    fail('value must be set when creating an userdb entry')
  }

  $changes = $ensure ? {
    'present' => [
      "set key[. = '${key}'] '${key}'",
      "set key[. = '${key}']/value '${value}'",
    ],
    'absent'  => "rm key[ . = '${key}']",
  }

  augeas { "${::sendmail::params::userdb_file}-${name}":
    lens    => 'Sendmail_Map.lns',
    incl    => $::sendmail::params::userdb_file,
    changes => $changes,
    require => Class['::sendmail::userdb::file'],
    notify  => Class['::sendmail::makeall'],
  }
}
