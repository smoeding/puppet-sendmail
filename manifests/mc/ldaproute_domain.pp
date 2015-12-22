# = Define: sendmail::mc::ldaproute_domain
#
# Add the LDAPROUTE_DOMAIN macro to the sendmail.mc file.
#
# == Parameters:
#
# [*domain*]
#   The name of the domain for which LDAP routing is enabled.
#   Default value is the resource title.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::mc::ldaproute_domain { 'example.net': }
#
#
define sendmail::mc::ldaproute_domain (
  $domain = $title,
) {
  include ::sendmail::makeall

  concat::fragment { "sendmail_mc-ldaproute_domain-${domain}":
    target  => 'sendmail.mc',
    order   => '19',
    content => inline_template("LDAPROUTE_DOMAIN(`<%= @domain -%>')dnl\n"),
    notify  => Class['::sendmail::makeall'],
  }

  # Also add the section header
  include ::sendmail::mc::ldap_section
}
