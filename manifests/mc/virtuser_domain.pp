# = Define: sendmail::mc::virtuser_domain
#
# Add the VIRTUSER_DOMAIN macro to the sendmail.mc file.
#
# == Parameters:
#
# [*domainname*]
#   The name of the domain to use with 'FEATURE(virtusertable)'. This can be
#   used multiple times to set more than one domain name.  Default value is
#   the resource title.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::mc::virtuser_domain { 'example.net': }
#
#
define sendmail::mc::virtuser_domain (
  Stdlib::Fqdn $domainname = $title,
) {
  concat::fragment { "sendmail_mc-virtuser_domain-${domainname}":
    target  => 'sendmail.mc',
    order   => '37',
    content => "VIRTUSER_DOMAIN(`${domainname}')dnl\n",
  }

  # Also add the section header
  include sendmail::mc::macro_section
}
