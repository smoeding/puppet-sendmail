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
  concat::fragment { 'sendmail_mc-local_config_header':
    target  => 'sendmail.mc',
    order   => '80',
    content => "dnl #\nLOCAL_CONFIG\n",
  }
}
