# = Class: sendmail::mc::macro_section
#
# Add a section header above the sendmail macros
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
#   class { 'sendmail::mc::macro_section': }
#
#
class sendmail::mc::macro_section {
  include ::sendmail::makeall

  concat::fragment { 'sendmail_mc-macro_header':
    target  => 'sendmail.mc',
    order   => '31',
    content => inline_template("dnl #\ndnl # Macros\ndnl #\n"),
    notify  => Class['::sendmail::makeall'],
  }
}
