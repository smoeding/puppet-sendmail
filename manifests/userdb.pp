# = Class: sendmail::userdb
#
# Manage the Sendmail userdb db file.
#
# == Parameters:
#
# [*content*]
#   The desired contents of the userdb file. This allows managing the userdb
#   file as a whole. Changes to the file automatically triggers a rebuild of
#   the userdb database file. This attribute is mutually exclusive with
#   'source'.
#
# [*source*]
#   A source file for the userdb file. This allows managing the userdb file
#   as a whole. Changes to the file automatically triggers a rebuild of the
#   userdb database file. This attribute is mutually exclusive with
#   'content'.
#
# [*entries*]
#   A hash that will be used to create sendmail::userdb::entry resources.
#   This class can be used to create userdb entries defined in hiera. The
#   hiera hash should look like this:
#
#   sendmail::userdb::entries:
#     'fred:maildrop':
#       value: 'fred@example.org'
#     'barney:maildrop':
#       value: 'barney@example.org'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'sendmail::userdb': }
#
#   class { 'sendmail::userdb':
#     source => 'puppet:///modules/sendmail/userdb',
#   }
#
#
class sendmail::userdb (
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

    class { 'sendmail::userdb::file':
      content => $content,
      source  => $source,
    }
  }
  elsif !empty($entries) {
    validate_hash($entries)
    create_resources('sendmail::userdb::entry', $entries)
  }
}
