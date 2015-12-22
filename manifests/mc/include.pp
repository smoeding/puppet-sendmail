# = Define: sendmail::mc::include
#
# Add include fragments to the sendmail.mc file.
#
# == Parameters:
#
# [*filename*]
#   The absolute path of the file to include.
#   Defaults to the resource title.
#
# [*order*]
#   The position in the sendmail.mc file where the include statement will
#   appear. This requires some internal knowledge of the sendmail module.
#   See the Puppet class 'sendmail::mc' for details.
#   Default: '59'. This generates the include statements just before the
#   MAILER section.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::mc::include { '/etc/mail/m4/clamav-milter.m4': }
#
#
define sendmail::mc::include (
  $filename = $title,
  $order    = '59',
) {
  include ::sendmail::makeall

  validate_absolute_path($filename)

  concat::fragment { "sendmail_mc-include-${title}":
    target  => 'sendmail.mc',
    order   => $order,
    content => inline_template("include(`<%= @filename -%>')dnl\n"),
    notify  => Class['::sendmail::makeall'],
  }
}
