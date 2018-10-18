# = Define: sendmail::mc::ostype
#
# Add the OSTYPE macro to the sendmail.mc file.
#
# == Parameters:
#
# [*ostype*]
#   The type of operating system as a string. The value is used to add
#   the 'OSTYPE' macro to the generated sendmail.mc file. This will
#   include the m4 file with operating system specific settings.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::mc::ostype { 'Debian': }
#
#
define sendmail::mc::ostype (
  String $ostype = $title,
) {
  include ::sendmail::makeall

  concat::fragment { "sendmail_mc-ostype-${ostype}":
    target  => 'sendmail.mc',
    order   => '05',
    content => "OSTYPE(`${ostype}')dnl\n",
    notify  => Class['::sendmail::makeall'],
  }
}
