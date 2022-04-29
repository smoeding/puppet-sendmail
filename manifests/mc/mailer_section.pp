# @summary Add a section header to improve readability of the config file
#
# @api private
#
#
class sendmail::mc::mailer_section {
  concat::fragment { 'sendmail_mc-mailer_header':
    target  => 'sendmail.mc',
    order   => '60',
    content => "dnl #\ndnl # Mailer\ndnl #\n",
  }
}
