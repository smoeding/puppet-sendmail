# @summary Add the `VERSIONID` macro to the sendmail.mc file.
#
# @example Set the `VERSIONID` to the value `generic`
#   sendmail::mc::versionid { 'generic': }
#
# @param versionid The identifier (a string) to set in the sendmail.mc file.
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
