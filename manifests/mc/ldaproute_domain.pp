# = Define: sendmail::mc::ldaproute_domain
#
# Add the LDAPROUTE_DOMAIN macro to the sendmail.mc file.
#
# == Parameters:
#
# [*domain_name*]
#   The name of the domain for which LDAP routing is enabled.
#   Default value is the resource title.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::mc::ldaproute_domain { 'example.net': }
#
#
define sendmail::mc::ldaproute_domain (
  String $domain_name = $title,
) {
  include ::sendmail::mc::ldap_section

  concat::fragment { "sendmail_mc-ldaproute_domain_name-${domain_name}":
    target  => 'sendmail.mc',
    order   => '19',
    content => "LDAPROUTE_DOMAIN(`${domain_name}')dnl\n",
  }
}
