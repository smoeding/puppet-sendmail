# = Define: sendmail::mc::mailer
#
# Add the MAILER macro to the sendmail.mc file.
#
# == Parameters:
#
# None.
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
    'smtp'     => '80',
    'local'    => '85',
    'procmail' => '87',
    'uucp'     => '87',
    'cyrus'    => '88',
    'cyrusv2'  => '88',
    'phquery'  => '88',
    'pop'      => '88',
    'usenet'   => '88',
    default    => '89',
  }

  concat::fragment { "sendmail_mc-mailer-${mailer}":
    target  => 'sendmail.mc',
    order   => $order,
    content => inline_template("MAILER(`<%= @mailer -%>')dnl\n"),
    notify  => Class['::sendmail::makeall'],
  }
}
