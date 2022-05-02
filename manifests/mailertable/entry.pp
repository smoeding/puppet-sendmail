# @summary Manage an entry in the Sendmail mailertable file.
#
# @example Forward all mail for the `example.com` domain to a given relay
#   sendmail::mailertable::entry { '.example.com':
#     value => 'smtp:relay.example.com',
#   }
#
# @example Reject all mail for the `example.net` domain with a given error
#   sendmail::mailertable::entry { '.example.net':
#     value => 'error:5.7.0:550 mail is not accepted',
#   }
#
# @param ensure Used to create or remove the mailertable db entry.  Valid
#   options: `present`, `absent`.
#
# @param key The key used by Sendmail for the lookup.  This should either be
#   a fully qualified host name or a domain name with a leading dot.
#
# @param value The value for the given key.  For the mailertable map this is
#   typically something like `smtp:hostname`.  The error mailer can be used
#   to configure specific errors for certain hosts.
#
#
define sendmail::mailertable::entry (
  Enum['present','absent'] $ensure = 'present',
  String                   $key    = $name,
  Optional[String]         $value  = undef,
) {
  include sendmail::params
  include sendmail::makeall
  include sendmail::mailertable::file

  if ($ensure == 'present' and empty($value)) {
    fail('value must be set when creating a mailertable entry')
  }

  $changes = $ensure ? {
    'present' => [
      "set key[. = '${key}'] '${key}'",
      "set key[. = '${key}']/value '${value}'",
    ],
    'absent'  => "rm key[ . = '${key}']",
  }

  augeas { "${::sendmail::params::mailertable_file}-${title}":
    lens    => 'Sendmail_Map.lns',
    incl    => $::sendmail::params::mailertable_file,
    changes => $changes,
    require => Class['sendmail::mailertable::file'],
    notify  => Class['sendmail::makeall'],
  }
}
