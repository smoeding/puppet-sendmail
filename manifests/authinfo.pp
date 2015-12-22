# = Class: sendmail::authinfo
#
# Manage the Sendmail authinfo db file.
#
# == Parameters:
#
# [*content*]
#   The desired contents of the authinfo file. This allows managing the
#   authinfo file as a whole. Changes to the file automatically triggers a
#   rebuild of the authinfo database file. This attribute is mutually
#   exclusive with 'source'.
#
# [*source*]
#   A source file for the authinfo file. This allows managing the authinfo
#   file as a whole. Changes to the file automatically triggers a rebuild of
#   the authinfo database file. This attribute is mutually exclusive with
#   'content'.
#
# [*entries*]
#   A hash that will be used to create sendmail::authinfo::entry resources.
#   This class can be used to create authinfo entries defined in hiera. The
#   hiera hash should look like this:
#
#   sendmail::authinfo::entries:
#     'AuthInfo:example.com':
#       value: '"U=auth" "P=secret"'
#     'AuthInfo:192.168.67.89':
#       value: '"U=fred" "P=wilma"'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'sendmail::authinfo': }
#
#   class { 'sendmail::authinfo':
#     source => 'puppet:///modules/sendmail/authinfo',
#   }
#
#
class sendmail::authinfo (
  $content = undef,
  $source  = undef,
  $entries = {},
) {

  if ($content and $source) {
    fail('You cannot specify more than one of content, source, entries')
  }

  if ($content or $source) {
    if !empty($entries) {
      fail('You cannot specify more than one of content, source, entries')
    }

    class { 'sendmail::authinfo::file':
      content => $content,
      source  => $source,
    }
  }
  elsif !empty($entries) {
    validate_hash($entries)
    create_resources('sendmail::authinfo::entry', $entries)
  }
}
