# = Define: sendmail::mc::virtuser_domain
#
# Add the VIRTUSER_DOMAIN macro to the sendmail.mc file.
#
# == Parameters:
#
# [*domain*]
#   The name of the domain to add to the VirtUser class.
#   Default value is the resource title.
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
  Stdlib::Fqdn $domain = $title,
) {
  concat::fragment { "sendmail_mc-virtuser_domain-${domain}":
    target  => 'sendmail.mc',
    order   => '37',
    content => "VIRTUSER_DOMAIN(`${domain}')dnl\n",
  }

  # Also add the section header
  include sendmail::mc::macro_section
}
