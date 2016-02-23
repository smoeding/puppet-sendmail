# = Define: sendmail::authinfo::entry
#
# Manage an entry in the Sendmail authinfo db file.
#
# == Parameters:
#
# [*password*]
#   The password used for remote authentication in clear text.
#   Exactly one of 'password' or 'password_base64' must be set.
#
# [*password_base64*]
#   The password used for remote authentication in Base64 encoding.
#   Exactly one of 'password' or 'password_base64' must be set.
#
# [*authorization_id*]
#   The user (authorization) identifier. One of the parameters
#   'authorization_id' or 'authentication_id' or both must be set. Default
#   value: 'undef'
#
# [*authentication_id*]
#   The authentication identifier. One of the parameters 'authorization_id'
#   or 'authentication_id' or both must be set. Default value: 'undef'
#
# [*realm*]
#   The administrative realm to use. Default value: 'undef'
#
# [*mechanisms*]
#   The list of preferred authentication mechanisms. Default value: '[]'
#
# [*address*]
#   The key used by Sendmail for the database lookup. This can be an IPv4
#   address (e.g. '192.168.67.89'), an IPv6 address (e.g.
#   'IPv6:2001:DB18::23f4'), a hostname (e.g. 'www.example.org') or a domain
#   name (e.g. 'example.com'). The database key requires to start with the
#   literal expression 'AuthInfo:'. This prefix will be added automatically
#   if necessary. Default value is the resource title.
#
# [*ensure*]
#   Used to create or remove the authinfo db entry. Default value: 'present'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::authinfo::entry { 'example.com':
#     password         => 'secret',
#     authorization_id => 'auth',
#   }
#
#
define sendmail::authinfo::entry (
  $password          = undef,
  $password_base64   = undef,
  $authorization_id  = undef,
  $authentication_id = undef,
  $realm             = undef,
  $mechanisms        = [],
  $address           = $title,
  $ensure            = 'present',
) {
  include ::sendmail::params
  include ::sendmail::makeall
  include ::sendmail::authinfo::file

  validate_re($ensure, [ 'present', 'absent' ])
  validate_array($mechanisms)

  if $address == undef {
    fail('The address parameter must be defined')
  }

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

  # Remove unset values by mapping them to a single '=' and deleting it
  $real_values = delete(regsubst($values, '^.[:=]$', '='), '=')

  # Add quotes to each array element
  $value = join(regsubst($real_values, '^.*$', '"\0"'), ' ')

  $changes = $ensure ? {
    'present' => [
      "set key[. = '${key}'] '${key}'",
      "set key[. = '${key}']/value '${value}'",
    ],
    'absent'  => "rm key[ . = '${key}']",
  }

  augeas { "${::sendmail::params::authinfo_file}-${key}":
    lens    => 'Sendmail_Map.lns',
    incl    => $::sendmail::params::authinfo_file,
    changes => $changes,
    require => Class['::sendmail::authinfo::file'],
    notify  => Class['::sendmail::makeall'],
  }
}
