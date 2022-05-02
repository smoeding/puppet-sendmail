# @summary Add a `MAILER` macro to the sendmail.mc file.
#
# @example Add the local mailer to the configuration
#   sendmail::mc::mailer { 'local': }
#
# @example Add the SMTP mailer to the configuration
#   sendmail::mc::mailer { 'smtp': }
#
# @param mailer The name of the mailer to add to the configuration.  The
#   position of the mailer in the configuration file is determined according
#   to the Bat Book.
#
#
define sendmail::mc::mailer (
  String $mailer = $name,
) {
  include sendmail::mc::mailer_section

  # Some mailers must be defined before others according to the Bat Book
  $order = $mailer ? {
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
    content => "MAILER(`${mailer}')dnl\n",
  }
}
