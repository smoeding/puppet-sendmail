# = Class: sendmail::mc::define_section
#
# Add a section header above the define statements
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
#   class { 'sendmail::mc::define_section': }
#
#
class sendmail::mc::define_section {
  include ::sendmail::makeall

  concat::fragment { 'sendmail_mc-define_header':
    target  => 'sendmail.mc',
    order   => '10',
    content => inline_template("dnl #\ndnl # Defines\ndnl #\n"),
    notify  => Class['::sendmail::makeall'],
  }
}
