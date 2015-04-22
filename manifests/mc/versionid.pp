# = Define: sendmail::mc::versionid
#
# Add the VERSIONID macro to the sendmail.mc file.
#
# == Parameters:
#
# [*versionid*]
#   The identifier (a string) to set in the sendmail.mc file.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::mc::versionid { 'generic': }
#
#
define sendmail::mc::versionid (
  $versionid = $title,
) {
  include ::sendmail::makeall

  concat::fragment { 'sendmail_mc-versionid':
    target  => 'sendmail.mc',
    order   => '01',
    content => inline_template("VERSIONID(`<%= @versionid -%>')dnl\n"),
    notify  => Class['::sendmail::makeall'],
  }
}
