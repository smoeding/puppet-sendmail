# @summary Add the `GENERICS_DOMAIN` macro to the sendmail.mc file.
#
# @example Enable genericstable processing for the domain `example.net`
#   sendmail::mc::generics_domain { 'example.net': }
#
# @param domain_name The name of the domain for which the genericstable is
#   enabled.
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
