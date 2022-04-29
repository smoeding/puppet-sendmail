# @summary Add the `TRUST_AUTH_MECH` macro to the sendmail.mc file.
#
# @example Activate `PLAIN` authentication
#   class { 'sendmail::mc::trust_auth_mech':
#     trust_auth_mech => 'PLAIN',
#   }
#
# @example Activate `PLAIN` and `DIGEST-MD5` authentication
#   class { 'sendmail::mc::trust_auth_mech':
#     trust_auth_mech => [ 'PLAIN', 'DIGEST-MD5', ],
#   }
#
# @param trust_auth_mech The value of the `TRUST_AUTH_MECH` macro to set.  If
#   this is a string it is used as-is.  For an array the value will be
#   concatenated into a string.
#
#
class sendmail::mc::trust_auth_mech (
  Variant[String,Array[String]] $trust_auth_mech,
) {
  include sendmail::mc::macro_section

  $mech = $trust_auth_mech ? {
    Array => join(strip($trust_auth_mech), ' '),
    default => strip($trust_auth_mech),
  }

  concat::fragment { 'sendmail_mc-trust_auth_mech':
    target  => 'sendmail.mc',
    order   => '45',
    content => "TRUST_AUTH_MECH(`${mech}')dnl\n",
  }
}
