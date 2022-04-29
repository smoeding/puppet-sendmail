# @summary Add a section header to improve readability of the config file
#
# @api private
#
#
class sendmail::mc::local_config_section {
  concat::fragment { 'sendmail_mc-local_config_header':
    target  => 'sendmail.mc',
    order   => '80',
    content => "dnl #\nLOCAL_CONFIG\n",
  }
}
