# = Define: sendmail::mc::domain
#
# Add the DOMAIN macro to the sendmail.mc file.
#
# == Parameters:
#
# [*domainname*]
#   The name of the sendmail domain file as a string. The value is used as
#   argument to the 'DOMAIN' macro to the generated sendmail.mc file. This
#   will include the m4 file with domain specific settings.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::mc::domain { 'generic': }
#
#
define sendmail::mc::domain (
  String $domainname = $title,
) {
  concat::fragment { "sendmail_mc-domain-${domainname}":
    target  => 'sendmail.mc',
    order   => '07',
    content => "DOMAIN(`${domainname}')dnl\n",
  }
}
