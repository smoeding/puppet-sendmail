# @summary Add a section header to improve readability of the config file
#
# @api private
#
#
class sendmail::mc::macro_section {
  concat::fragment { 'sendmail_mc-macro_header':
    target  => 'sendmail.mc',
    order   => '35',
    content => "dnl #\ndnl # Macros\ndnl #\n",
  }
}
