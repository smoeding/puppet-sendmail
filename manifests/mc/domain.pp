# @summary Add the `DOMAIN` macro to the sendmail.mc file.
#
# @example Include settings for the `generic` domain
#   sendmail::mc::domain { 'generic': }
#
# @param domain_name The name of the sendmail domain file as a string.  The
#   value is used as argument to the `DOMAIN` macro in the generated
#   sendmail.mc file.  This will include the m4 file with domain specific
#   settings.
#
#
define sendmail::mc::domain (
  String $domain_name = $title,
) {
  concat::fragment { "sendmail_mc-domain-${domain_name}":
    target  => 'sendmail.mc',
    order   => '07',
    content => "DOMAIN(`${domain_name}')dnl\n",
  }
}
