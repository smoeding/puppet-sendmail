# @summary Add a section header to improve readability of the config file
#
# @api private
#
#
class sendmail::mc::queue_group_section {
  concat::fragment { 'sendmail_mc-queue_group_header':
    target  => 'sendmail.mc',
    order   => '33',
    content => "dnl #\ndnl # Queue Group\ndnl #\n",
  }
}
