# = Class: sendmail::mc::milter_section
#
# Add a section header above the sendmail milters
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
#   class { 'sendmail::mc::milter_section': }
#
#
class sendmail::mc::milter_section {
  include ::sendmail::makeall

  concat::fragment { 'sendmail_mc-milter_header':
    target  => 'sendmail.mc',
    order   => '55',
    content => inline_template("dnl #\ndnl # Milter\ndnl #\n"),
    notify  => Class['::sendmail::makeall'],
  }
}
