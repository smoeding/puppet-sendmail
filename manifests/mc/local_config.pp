# = Define: local_config
#
# Manage local_config
#
# == Parameters:
#
# [*ensure*]
#   Ensure parameter passed onto Service[] resources.
#   Default: running
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::mc::local_config { 'local_config':
#
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
