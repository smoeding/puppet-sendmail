# = Define: local_config
#
# Add a LOCAL_CONFIG section into the sendmail.mc file.
#
# == Parameters:
#
# [*content*]
#   The desired contents of the local config section. This attribute is
#   mutually exclusive with 'source'.
#
# [*source*]
#   A source file included as the local config section. This attribute is
#   mutually exclusive with 'content'.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::mc::local_config { 'X-AuthUser':
#     content => 'HX-AuthUser: ${auth_authen}',
#   }
#
#
define sendmail::mc::local_config (
  $content = undef,
  $source  = undef,
) {

  if $content and $source {
    fail('sendmail::mc::local_config cannot have both content and source')
  }

  if !$content and !$source {
    fail('sendmail::mc::local_config needs either of content or source')
  }

  concat::fragment { "sendmail_mc-local_config-${title}":
    target  => 'sendmail.mc',
    order   => '81',
    content => $content,
    source  => $source,
    notify  => Class['::sendmail::makeall'],
  }

  # Also add the section header
  include ::sendmail::mc::local_config_section
}
