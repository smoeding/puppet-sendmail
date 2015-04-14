# = Define: sendmail::mc::versionid
#
# Add the VERSIONID macro to the sendmail.mc file.
#
# == Parameters:
#
# [*versionid*]
#   The identifier to add to the sendmail.mc file.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'sendmail::mc::versionid':
#     versionid => 'generic',
#   }
#
#
define sendmail::mc::versionid (
  $versionid = $title,
) {
  include ::sendmail::makeall

  concat::fragment { 'sendmail_mc-versionid':
    target  => 'sendmail.mc',
    order   => '10',
    content => inline_template("VERSIONID(`<%= @versionid -%>')dnl\n"),
    notify  => Class['::sendmail::makeall'],
  }
}
