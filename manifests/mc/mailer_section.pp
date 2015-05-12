# = Class: sendmail::mc::mailer_section
#
# Add a section header above the mailer macros
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
#   class { 'sendmail::mc::mailer_section': }
#
#
class sendmail::mc::mailer_section {
  include ::sendmail::makeall

  concat::fragment { 'sendmail_mc-mailer_header':
    target  => 'sendmail.mc',
    order   => '60',
    content => inline_template("dnl #\ndnl # Mailer\ndnl #\n"),
    notify  => Class['::sendmail::makeall'],
  }
}
