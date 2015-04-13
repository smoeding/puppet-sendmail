# = Class: sendmail::versionid
#
# Add the VERSIONID macro to the sendmail.mc file.
#
# == Parameters:
#
# [*versionid*]
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'sendmail::versionid':
#     versionid => 'generic',
#   }
#
#
class sendmail::versionid ($versionid) {
  include ::sendmail::makeall

  concat::fragment { 'sendmail_mc-versionid':
    target  => 'sendmail.mc',
    order   => '10',
    content => inline_template("VERSIONID(`<%= @versionid -%>')dnl\n"),
    notify  => Class['::sendmail::makeall'],
  }
}
