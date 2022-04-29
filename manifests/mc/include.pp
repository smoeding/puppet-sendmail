# @summary Add include fragments to the sendmail.mc file.
#
# @example Include a milter setup file to the configuration
#   sendmail::mc::include { '/etc/mail/m4/clamav-milter.m4': }
#
# @param filename The absolute path of the file to include.
#
# @param order The position in the sendmail.mc file where the include
#   statement will appear.  This requires internal knowledge of the sendmail
#   module.  See the Puppet class `sendmail::mc` for details.  The default
#   generates the include statements just before the `MAILER` section.
#
#
define sendmail::mc::include (
  Stdlib::Absolutepath $filename = $title,
  String               $order    = '59',
) {
  concat::fragment { "sendmail_mc-include-${title}":
    target  => 'sendmail.mc',
    order   => $order,
    content => "include(`${filename}')dnl\n",
  }
}
