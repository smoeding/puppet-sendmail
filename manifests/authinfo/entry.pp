# = Define: sendmail::authinfo::entry
#
# Create entries in the Sendmail authinfo db file.
#
# == Parameters:
#
# [*password*]
#   The password used for remote authentication. Base64 encoded passwords are
#   not implemented yet. This parameter is mandatory.
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
# [*key*]
#   The key used by Sendmail for the lookup. Normally this has one of the
#   following formats: 'AuthInfo:192.168.67.89' (IPv4 address),
#   'AuthInfo:IPv6:2001:DB18::23f4' (IPv6 address),
#   'AuthInfo:www.example.org' (hostname) or 'AuthInfo:example.com' (domain
#   name). Default value is the resource title. In this case the 'AuthInfo:'
#   prefix is added automatically.
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
#     password          => 'secret',
#     authentication_id => 'auth',
#   }
#
#
define sendmail::authinfo::entry (
  $password,
  $authorization_id  = undef,
  $authentication_id = undef,
  $realm             = undef,
  $mechanisms        = [],
  $key               = "AuthInfo:${title}",
  $ensure            = 'present',
) {
  include ::sendmail::params
  include ::sendmail::makeall
  include ::sendmail::authinfo::file

  validate_re($ensure, [ 'present', 'absent' ])
  validate_array($mechanisms)

  if $ensure == 'present' and !$authorization_id and !$authentication_id {
    fail('Either authorization_id or authentication_id or both must be set')
  }

  $value_hash = delete_undef_values({
      'U' => $authorization_id,
      'I' => $authentication_id,
      'P' => $password,
      'R' => $realm,
      'M' => join($mechanisms, ' '),
  })

  # FIXME: Base64 encoded values must use '=' instead of ':'
  $value_pairs = join_keys_to_values($value_hash, ':')

  # Add quotes to each array element
  $value = join(regsubst($value_pairs, '^.*$', '"\0"'), ' ')

  $changes = $ensure ? {
    'present' => [
      "set key[. = '${key}'] '${key}'",
      "set key[. = '${key}']/value '${value}'",
    ],
    'absent'  => "rm key[ . = '${key}']",
  }

  augeas { "${::sendmail::params::authinfo_file}-${title}":
    lens    => 'Sendmail_Map.lns',
    incl    => $::sendmail::params::authinfo_file,
    changes => $changes,
    require => Class['::sendmail::authinfo::file'],
    notify  => Class['::sendmail::makeall'],
  }
}
