# @summary Add the `OSTYPE` macro to the sendmail.mc file.
#
# @example Set the `OSTYPE` to Debian
#   sendmail::mc::ostype { 'Debian': }
#
# @param ostype The type of operating system as a string.  The value is used
#   to add the `OSTYPE` macro to the generated sendmail.mc file.  This will
#   include the m4 file with operating system specific settings.
#
#
define sendmail::mc::ostype (
  String $ostype = $title,
) {
  concat::fragment { "sendmail_mc-ostype-${ostype}":
    target  => 'sendmail.mc',
    order   => '05',
    content => "OSTYPE(`${ostype}')dnl\n",
  }
}
