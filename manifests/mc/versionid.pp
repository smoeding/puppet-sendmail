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
  String $versionid = $title,
) {
  concat::fragment { 'sendmail_mc-versionid':
    target  => 'sendmail.mc',
    order   => '01',
    content => "VERSIONID(`${versionid}')dnl\n",
  }
}
