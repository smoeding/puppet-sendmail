# @summary Add a section header above the ldap settings
#
# @api private
#
#
class sendmail::mc::ldap_section {
  concat::fragment { 'sendmail_mc-ldap_header':
    target  => 'sendmail.mc',
    order   => '18',
    content => "dnl #\ndnl # LDAP\ndnl #\n",
  }
}
