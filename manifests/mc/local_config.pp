# @summary Add a `LOCAL_CONFIG` section into the sendmail.mc file.
#
# @example Add the X-AuthUser header to each mail
#   sendmail::mc::local_config { 'X-AuthUser':
#     content => 'HX-AuthUser: ${auth_authen}',
#   }
#
# @param content The desired contents of the local config section.  This
#   attribute is mutually exclusive with `source`.
#
# @param source A source file included as the local config section.  This
#   attribute is mutually exclusive with `content`.
#
#
define sendmail::mc::local_config (
  Optional[String] $content = undef,
  Optional[String] $source  = undef,
) {
  include sendmail::mc::local_config_section

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
  }
}
