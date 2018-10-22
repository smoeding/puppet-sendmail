# = Define: sendmail::mc::generics_domain
#
# Add the GENERICS_DOMAIN macro to the sendmail.mc file.
#
# == Parameters:
#
# [*domain*]
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
  String $domain = $title,
) {
  concat::fragment { "sendmail_mc-generics_domain-${domain}":
    target  => 'sendmail.mc',
    order   => '32',
    content => "GENERICS_DOMAIN(`${domain}')dnl\n",
  }
}
