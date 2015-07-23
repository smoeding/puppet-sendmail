# = Class: sendmail::mc::ldap_section
#
# Add a section header above the ldap settings
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
#   class { 'sendmail::mc::ldap_section': }
#
#
class sendmail::mc::ldap_section {
  include ::sendmail::makeall

  concat::fragment { 'sendmail_mc-ldap_header':
    target  => 'sendmail.mc',
    order   => '18',
    content => inline_template("dnl #\ndnl # LDAP\ndnl #\n"),
    notify  => Class['::sendmail::makeall'],
  }
}
