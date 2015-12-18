# = Define: sendmail::access::entry
#
# Manage an entry in the Sendmail access db file.
#
# == Parameters:
#
# [*value*]
#   The value for the given key. For the access map this is typically
#   something like OK, REJECT or DISCARD.
#
# [*key*]
#   The key used by Sendmail for the lookup. This could for example be a
#   domain name. Default is the resource title.
#
# [*ensure*]
#   Used to create or remove the access db entry.
#   Valid options: 'present', 'absent'. Default: 'present'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::access::entry { 'example.com':
#     value => 'RELAY',
#   }
#
#
define sendmail::access::entry (
  $value  = undef,
  $key    = $title,
  $ensure = 'present',
) {
  include ::sendmail::params
  include ::sendmail::makeall
  include ::sendmail::access::file

  validate_re($ensure, [ 'present', 'absent' ])

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
    require => Class['::sendmail::access::file'],
    notify  => Class['::sendmail::makeall'],
  }
}
