# = Define: sendmail::mc::mailer
#
# Add a MAILER macro to the sendmail.mc file.
#
# == Parameters:
#
# [*mailer*]
#   The name of the mailer to add to the configuration. Default is the
#   resource title.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::mc::mailer { 'local': }
#
#   sendmail::mc::mailer { 'smtp': }
#
#
define sendmail::mc::mailer (
  $mailer = $title,
) {
  include ::sendmail::makeall

  # Some mailers must be defined before others according to the Bat Book
  $order = $title ? {
    'smtp'     => '61',
    'local'    => '65',
    'procmail' => '67',
    'uucp'     => '67',
    'cyrus'    => '68',
    'cyrusv2'  => '68',
    'phquery'  => '68',
    'pop'      => '68',
    'usenet'   => '68',
    default    => '69',
  }

  concat::fragment { "sendmail_mc-mailer-${mailer}":
    target  => 'sendmail.mc',
    order   => $order,
    content => inline_template("MAILER(`<%= @mailer -%>')dnl\n"),
    notify  => Class['::sendmail::makeall'],
  }

  # Also add the section header
  include ::sendmail::mc::mailer_section
}
