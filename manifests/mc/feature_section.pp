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
  include ::sendmail::makeall

  concat::fragment { 'sendmail_mc-feature_header':
    target  => 'sendmail.mc',
    order   => '20',
    content => inline_template("dnl #\ndnl # Features\ndnl #\n"),
    notify  => Class['::sendmail::makeall'],
  }
}
