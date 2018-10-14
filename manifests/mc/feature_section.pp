# = Class: sendmail::mc::feature_section
#
# Add a section header above the feature macros
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
#   class { 'sendmail::mc::feature_section': }
#
#
class sendmail::mc::feature_section {
  concat::fragment { 'sendmail_mc-feature_header':
    target  => 'sendmail.mc',
    order   => '20',
    content => "dnl #\ndnl # Features\ndnl #\n",
  }
}
