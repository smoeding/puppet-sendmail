# @summary Add a section header to improve readability of the config file
#
# @api private
#
#
class sendmail::mc::define_section {
  concat::fragment { 'sendmail_mc-define_header':
    target  => 'sendmail.mc',
    order   => '10',
    content => "dnl #\ndnl # Defines\ndnl #\n",
  }
}
