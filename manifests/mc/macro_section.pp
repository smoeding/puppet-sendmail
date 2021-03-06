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
  concat::fragment { 'sendmail_mc-macro_header':
    target  => 'sendmail.mc',
    order   => '35',
    content => "dnl #\ndnl # Macros\ndnl #\n",
  }
}
