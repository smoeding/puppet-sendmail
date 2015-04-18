# = Define: sendmail::mailertable::entry
#
# Create entries in the Sendmail mailertable db file.
#
# == Parameters:
#
# [*value*]
#   The value for the given key. For the mailertable map this is typically
#   something like smtp:hostname. The error mailer can be used to configure
#   specific errors for certain hosts.
#
# [*key*]
#   The key used by Sendmail for the lookup. This should either be a fully
#   qualified host name or a domain name with a leading dot.
#
# [*ensure*]
#   Used to create or remove the mailertable db entry.
#   Default: present
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::mailertable::entry { '.example.com':
#     value => 'smtp:relay.example.com',
#   }
#
#   sendmail::mailertable::entry { '.example.net':
#     value => 'error:5.7.0:550 mail is not accepted',
#   }
#
define sendmail::mailertable::entry (
  $value  = undef,
  $key    = $name,
  $ensure = present,
) {
  include ::sendmail::params
  include ::sendmail::makeall
  include ::sendmail::mailertable::file

  if ($ensure == present and empty($value)) {
    fail('value must be set when creating an mailertable entry')
  }

  $changes = $ensure ? {
    'present' => [
      "set key[. = '${key}'] '${key}'",
      "set key[. = '${key}']/value '${value}'",
    ],
    'absent'  => "rm key[ . = '${key}']",
  }

  augeas { "${::sendmail::params::mailertable_file}-${name}":
    lens    => 'Sendmail_Map.lns',
    incl    => $::sendmail::params::mailertable_file,
    changes => $changes,
    require => Class['::sendmail::mailertable::file'],
    notify  => Class['::sendmail::makeall'],
  }
}
