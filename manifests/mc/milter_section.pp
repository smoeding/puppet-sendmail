# @summary Add a section header to improve readability of the config file
#
# @api private
#
#
class sendmail::mc::milter_section {
  concat::fragment { 'sendmail_mc-milter_header':
    target  => 'sendmail.mc',
    order   => '55',
    content => "dnl #\ndnl # Milter\ndnl #\n",
  }
}
