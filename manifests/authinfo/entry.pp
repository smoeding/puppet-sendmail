# = Define: sendmail::authinfo::entry
#
# Create entries in the Sendmail authinfo db file.
#
# == Parameters:
#
# [*value*]
#   The value for the given key. For the authinfo map this is typically
#   a string composed of letter and value pairs where each pair is quoted
#   and separated from the orthers by space characters. Example:
#   "U=username" "P=password"
#
# [*key*]
#   The key used by Sendmail for the lookup. This normally has one of the
#   following formats:
#   AuthInfo:192.168.67.89
#   AuthInfo:IPv6:2001:DB8::23f4
#   AuthInfo:www.example.org
#   AuthInfo:example.com
#
# [*ensure*]
#   Used to create or remove the authinfo db entry.
#   Default: present
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::authinfo::entry { 'AuthInfo:example.com':
#     value => '"U=auth" "P=secret"',
#   }
#
#
define sendmail::authinfo::entry (
  $value  = undef,
  $key    = $name,
  $ensure = present,
) {
  include ::sendmail::params
  include ::sendmail::makeall
  include ::sendmail::authinfo::file

  if ($ensure == present and empty($value)) {
    fail('value must be set when creating an authinfo entry')
  }

  $changes = $ensure ? {
    'present' => [
      "set key[. = '${key}'] '${key}'",
      "set key[. = '${key}']/value '${value}'",
    ],
    'absent'  => "rm key[ . = '${key}']",
  }

  augeas { "${::sendmail::params::authinfo_file}-${name}":
    lens    => 'Sendmail_Map.lns',
    incl    => $::sendmail::params::authinfo_file,
    changes => $changes,
    require => Class['::sendmail::authinfo::file'],
    notify  => Class['::sendmail::makeall'],
  }
}
