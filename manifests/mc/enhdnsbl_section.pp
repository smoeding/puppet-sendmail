# = Class: sendmail::mc::enhdnsbl_section
#
# Add a section header above the enhdnsbl FEATURE macros
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
#   class { 'sendmail::mc::enhdnsbl_section': }
#
#
class sendmail::mc::enhdnsbl_section {
  include ::sendmail::makeall

  concat::fragment { 'sendmail_mc-enhdnsbl_header':
    target  => 'sendmail.mc',
    order   => '50',
    content => inline_template("dnl #\ndnl # DNS Blacklists\ndnl #\n"),
    notify  => Class['::sendmail::makeall'],
  }
}
