# = Define: sendmail::mc::generics_domain
#
# Add the GENERICS_DOMAIN macro to the sendmail.mc file.
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
#   sendmail::mc::generics_domain { 'example.net': }
#
#
define sendmail::mc::generics_domain (
  String $domain_name = $title,
) {
  concat::fragment { "sendmail_mc-generics_domain_name-${domain_name}":
    target  => 'sendmail.mc',
    order   => '32',
    content => "GENERICS_DOMAIN(`${domain_name}')dnl\n",
  }
}
