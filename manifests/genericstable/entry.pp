# @summary Manage an entry in the Sendmail genericstable file.
#
# @example Override the recipient `fred@example.com` with another address
#   sendmail::genericstable::entry { 'fred@example.com':
#     value => 'fred@example.org',
#   }
#
# @example Forward local mail to `barney` to a remote address
#   sendmail::genericstable::entry { 'barney':
#     value => 'barney@example.org',
#   }
#
# @param ensure Used to create or remove the genericstable db entry.  Valid
#   options: `present`, `absent`.
#
# @param key The key used by Sendmail for the lookup.  This is normally
#   a username or a user and domain name.
#
# @param value The value for the given key.  For the genericstable map this
#   is typically something like `user@example.org`.
#
#
define sendmail::genericstable::entry (
  Enum['present','absent'] $ensure = 'present',
  String                   $key    = $name,
  Optional[String]         $value  = undef,
) {
  include sendmail::params
  include sendmail::makeall
  include sendmail::genericstable::file

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
    require => Class['sendmail::genericstable::file'],
    notify  => Class['sendmail::makeall'],
  }
}
