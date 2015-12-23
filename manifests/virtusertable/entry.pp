# = Define: sendmail::virtusertable::entry
#
# Manage an entry in the Sendmail virtusertable db file.
#
# == Parameters:
#
# [*value*]
#   The value for the given key. For the virtusertable map this is typically
#   a local username or a remote mail address.
#
# [*key*]
#   The key used by Sendmail for the lookup. This is normally a mail address
#   or a mail address without the user part. Default is the resource title.
#
# [*ensure*]
#   Used to create or remove the virtusertable db entry.
#   Valid options: 'present', 'absent'. Default: 'present'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::virtusertable::entry { 'info@example.com':
#     value => 'fred@example.com',
#   }
#
#   sendmail::virtusertable::entry { '@example.org':
#     value => 'barney',
#   }
#
#
define sendmail::virtusertable::entry (
  $value  = undef,
  $key    = $title,
  $ensure = 'present',
) {
  include ::sendmail::params
  include ::sendmail::makeall
  include ::sendmail::virtusertable::file

  validate_re($ensure, [ 'present', 'absent' ])

  if ($ensure == 'present' and empty($value)) {
    fail('value must be set when creating a virtusertable entry')
  }

  $changes = $ensure ? {
    'present' => [
      "set key[. = '${key}'] '${key}'",
      "set key[. = '${key}']/value '${value}'",
    ],
    'absent'  => "rm key[ . = '${key}']",
  }

  augeas { "${::sendmail::params::virtusertable_file}-${title}":
    lens    => 'Sendmail_Map.lns',
    incl    => $::sendmail::params::virtusertable_file,
    changes => $changes,
    require => Class['::sendmail::virtusertable::file'],
    notify  => Class['::sendmail::makeall'],
  }
}
