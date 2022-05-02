# @summary Add the `LDAPROUTE_DOMAIN` macro to the sendmail.mc file.
#
# @example Enable LDAP routing for `example.net`
#   sendmail::mc::ldaproute_domain { 'example.net': }
#
# @param domain_name The name of the domain for which LDAP routing is
#   enabled.
#
#
define sendmail::mc::ldaproute_domain (
  String $domain_name = $name,
) {
  include sendmail::mc::ldap_section

  concat::fragment { "sendmail_mc-ldaproute_domain_name-${domain_name}":
    target  => 'sendmail.mc',
    order   => '19',
    content => "LDAPROUTE_DOMAIN(`${domain_name}')dnl\n",
  }
}
