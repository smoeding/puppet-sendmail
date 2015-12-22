# = Define: sendmail::mc::domain
#
# Add the DOMAIN macro to the sendmail.mc file.
#
# == Parameters:
#
# [*domain*]
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
  $domain = $title,
) {
  include ::sendmail::makeall

  concat::fragment { "sendmail_mc-domain-${domain}":
    target  => 'sendmail.mc',
    order   => '07',
    content => inline_template("DOMAIN(`<%= @domain -%>')dnl\n"),
    notify  => Class['::sendmail::makeall'],
  }
}
