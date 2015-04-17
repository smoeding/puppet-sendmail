# = Define: sendmail::domaintable::entry
#
# Create entries in the Sendmail domaintable db file.
#
# == Parameters:
#
# [*value*]
#   The value for the given key. For the domaintable map this is typically
#   another domain name.
#
# [*key*]
#   The key used by Sendmail for the lookup. This should normally be a
#   domain name.
#
# [*ensure*]
#   Used to create or remove the domaintable db entry.
#   Default: present
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::domaintable::entry { 'example.com':
#     value => 'example.org',
#   }
#
#
define sendmail::domaintable::entry (
  $value  = undef,
  $key    = $name,
  $ensure = present,
) {
  include ::sendmail::params
  include ::sendmail::makeall
  include ::sendmail::domaintable::file

  if ($ensure == present and empty($value)) {
    fail('value must be set when creating an domaintable entry')
  }

  $changes = $ensure ? {
    'present' => [
      "set key[. = '${key}'] '${key}'",
      "set key[. = '${key}']/value '${value}'",
    ],
    'absent'  => "rm key[ . = '${key}']",
  }

  augeas { "${::sendmail::params::domaintable_file}-${name}":
    lens    => 'Sendmail_Map.lns',
    incl    => $::sendmail::params::domaintable_file,
    changes => $changes,
    require => Class['::sendmail::domaintable::file'],
    notify  => Class['::sendmail::makeall'],
  }
}
