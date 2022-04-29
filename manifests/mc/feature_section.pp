# @summary Add a section header to improve readability of the config file
#
# @api private
#
#
class sendmail::mc::feature_section {
  concat::fragment { 'sendmail_mc-feature_header':
    target  => 'sendmail.mc',
    order   => '20',
    content => "dnl #\ndnl # Features\ndnl #\n",
  }
}
