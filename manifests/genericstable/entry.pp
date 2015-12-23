# = Define: sendmail::genericstable::entry
#
# Manage an entry in the Sendmail genericstable db file.
#
# == Parameters:
#
# [*value*]
#   The value for the given key. For the genericstable map this is typically
#   something like 'user@example.org'.
#
# [*key*]
#   The key used by Sendmail for the lookup. This is normally a username or
#   a user and domain name. Default is the resource title.
#
# [*ensure*]
#   Used to create or remove the genericstable db entry.
#   Valid options: 'present', 'absent'. Default: 'present'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::genericstable::entry { 'fred@example.com':
#     value => 'fred@example.org',
#   }
#
#   sendmail::genericstable::entry { 'barney':
#     value => 'barney@example.org',
#   }
#
#
define sendmail::genericstable::entry (
  $value  = undef,
  $key    = $title,
  $ensure = 'present',
) {
  include ::sendmail::params
  include ::sendmail::makeall
  include ::sendmail::genericstable::file

  validate_re($ensure, [ 'present', 'absent' ])

  if ($ensure == 'present' and empty($value)) {
    fail('value must be set when creating a genericstable entry')
  }

  $changes = $ensure ? {
    'present' => [
      "set key[. = '${key}'] '${key}'",
      "set key[. = '${key}']/value '${value}'",
    ],
    'absent'  => "rm key[ . = '${key}']",
  }

  augeas { "${::sendmail::params::genericstable_file}-${title}":
    lens    => 'Sendmail_Map.lns',
    incl    => $::sendmail::params::genericstable_file,
    changes => $changes,
    require => Class['::sendmail::genericstable::file'],
    notify  => Class['::sendmail::makeall'],
  }
}
