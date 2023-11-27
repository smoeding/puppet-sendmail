# @summary Manage an entry in the Sendmail authinfo db file.
#
# @example Add an authinfo entry
#   sendmail::authinfo::entry { 'example.com':
#     password         => 'secret',
#     authorization_id => 'auth',
#   }
#
# @param ensure Used to create or remove the authinfo db entry.
#
# @param mechanisms The list of preferred authentication mechanisms.
#
# @param address The key used by Sendmail for the database lookup.  This can
#   be an IPv4 address (e.g. `192.168.67.89`), an IPv6 address (e.g.
#   `IPv6:2001:DB18::23f4`), a hostname (e.g. `www.example.org`) or a domain
#   name (e.g. `example.com`).  The database key is required to start with
#   the literal expression `AuthInfo:`.  This prefix will be added
#   automatically if necessary.
#
# @param password The password used for remote authentication in clear text.
#   Exactly one of `password` or `password_base64` must be set.
#
# @param password_base64 The password used for remote authentication in
#   Base64 encoding.  Exactly one of `password` or `password_base64` must be
#   set.
#
# @param authorization_id The user (authorization) identifier.  One of the
#   parameters `authorization_id` or `authentication_id` or both must be set.
#
# @param authentication_id The authentication identifier.  One of the
#   parameters `authorization_id` or `authentication_id` or both must be set.
#
# @param realm The administrative realm to use.
#
#
define sendmail::authinfo::entry (
  Enum['present','absent'] $ensure            = 'present',
  Array[String]            $mechanisms        = [],
  String                   $address           = $name,
  Optional[String]         $password          = undef,
  Optional[String]         $password_base64   = undef,
  Optional[String]         $authorization_id  = undef,
  Optional[String]         $authentication_id = undef,
  Optional[String]         $realm             = undef,
) {
  include sendmail::params
  include sendmail::makeall
  include sendmail::authinfo::file

  if $ensure == 'present' {
    if ($password == undef) and ($password_base64 == undef) {
      fail('Either password or password_base64 must be set')
    }

    if ($password != undef) and ($password_base64 != undef) {
      fail('Only one of password and password_base64 can be set')
    }

    if ($authorization_id == undef) and ($authentication_id == undef) {
      fail('Either authorization_id or authentication_id or both must be set')
    }
  }

  # The key must start with the literal expression 'AuthInfo:'
  $key = $address ? {
    /^AuthInfo:/ => $address,
    default      => "AuthInfo:${address}"
  }

  # List of mechanisms
  $mech = empty($mechanisms) ? {
    true    => undef,
    default => join($mechanisms, ' ')
  }

  # Base64 encoded values use '=' while clear text values use ':'
  $values = [
    "U:${authorization_id}",
    "I:${authentication_id}",
    "P:${password}",
    "P=${password_base64}",
    "R:${realm}",
    "M:${mech}",
  ]

  # Remove unset values (value containing only 2 characters)
  $real_values = $values.filter |$item| { length($item) > 2 }

  # Add quotes to each array element
  $quoted_values = $real_values.map |$item| { "\"${item}\"" }

  # Join to a single string
  $value = join($quoted_values, ' ')

  $changes = $ensure ? {
    'present' => [
      "set key[. = '${key}'] '${key}'",
      "set key[. = '${key}']/value '${value}'",
    ],
    'absent'  => "rm key[ . = '${key}']",
  }

  augeas { "${sendmail::params::authinfo_file}-${key}":
    lens    => 'Sendmail_Map.lns',
    incl    => $sendmail::params::authinfo_file,
    changes => $changes,
    require => Class['sendmail::authinfo::file'],
    notify  => Class['sendmail::makeall'],
  }
}
