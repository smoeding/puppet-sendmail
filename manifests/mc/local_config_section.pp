# = Class: sendmail::mc::local_config_section
#
# Add a section header for the LOCAL_CONFIG macro
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
#   class { 'sendmail::mc::local_config_section': }
#
#
class sendmail::mc::local_config_section {
  include ::sendmail::makeall

  concat::fragment { 'sendmail_mc-local_config_header':
    target  => 'sendmail.mc',
    order   => '80',
    content => inline_template("dnl #\nLOCAL_CONFIG\n"),
    notify  => Class['::sendmail::makeall'],
  }
}
