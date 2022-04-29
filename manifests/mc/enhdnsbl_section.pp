# @summary Add a section header to improve readability of the config file
#
# @api private
#
#
class sendmail::mc::enhdnsbl_section {
  concat::fragment { 'sendmail_mc-enhdnsbl_header':
    target  => 'sendmail.mc',
    order   => '50',
    content => "dnl #\ndnl # DNS Blacklists\ndnl #\n",
  }
}
