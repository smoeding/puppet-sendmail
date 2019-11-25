# = Class: sendmail::mc::queue_group_section
#
# Add a section header above the queue_group statements
#
# == Parameters:
#
# None.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'sendmail::mc::queue_group_section': }
#
#
class sendmail::mc::queue_group_section {
  concat::fragment { 'sendmail_mc-queue_group_header':
    target  => 'sendmail.mc',
    order   => '30',
    content => "dnl #\ndnl # Queue Group\ndnl #\n",
  }
}
