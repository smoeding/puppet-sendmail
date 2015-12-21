# = Class: sendmail::access
#
# Manage the Sendmail access db file.
#
# == Parameters:
#
# [*content*]
#   The desired contents of the access file. This allows managing the access
#   file as a whole. Changes to the file automatically triggers a rebuild of
#   the access database file. This attribute is mutually exclusive with
#   'source'.
#
# [*source*]
#   A source file for the access file. This allows managing the access file
#   as a whole. Changes to the file automatically triggers a rebuild of the
#   access database file. This attribute is mutually exclusive with
#   'content'.
#
# [*entries*]
#   A hash that will be used to create sendmail::access::entry resources. The
#   class can be used to create access entries defined in hiera. The hiera
#   hash should look like this:
#
#   sendmail::access::entries:
#     'example.com':
#       value: 'OK'
#     'example.org':
#       value: 'REJECT'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'sendmail::access': }
#
#   class { 'sendmail::access':
#     source => 'puppet:///modules/sendmail/access',
#   }
#
#
class sendmail::access (
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

    class { 'sendmail::access::file':
      content => $content,
      source  => $source,
    }
  }
  elsif !empty($entries) {
    validate_hash($entries)
    create_resources('sendmail::access::entry', $entries)
  }
}
