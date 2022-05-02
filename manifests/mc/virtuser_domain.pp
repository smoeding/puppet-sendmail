# @summary Add the `VIRTUSER_DOMAIN` macro to the sendmail.mc file.
#
# @example
#   sendmail::mc::virtuser_domain { 'example.net': }
#
# @param domainname The name of the domain to use with
#   `FEATURE(virtusertable)`.  This can be used multiple times to set more
#   than one domain name.
#
#
define sendmail::mc::virtuser_domain (
  Stdlib::Fqdn $domainname = $name,
) {
  concat::fragment { "sendmail_mc-virtuser_domain-${domainname}":
    target  => 'sendmail.mc',
    order   => '37',
    content => "VIRTUSER_DOMAIN(`${domainname}')dnl\n",
  }

  # Also add the section header
  include sendmail::mc::macro_section
}
