# = Class: sendmail::virtusertable
#
# Manage the Sendmail virtusertable db file.
#
# == Parameters:
#
# [*content*]
#   The desired contents of the virtusertable file. This allows managing the
#   virtusertable file as a whole. Changes to the file automatically triggers
#   a rebuild of the virtusertable database file. This attribute is mutually
#   exclusive with 'source'.
#
# [*source*]
#   A source file for the virtusertable file. This allows managing the
#   virtusertable file as a whole. Changes to the file automatically triggers
#   a rebuild of the virtusertable database file. This attribute is mutually
#   exclusive with 'content'.
#
# [*entries*]
#   A hash that will be used to create sendmail::virtusertable::entry
#   resources. This class can be used to create virtusertable entries defined
#   in hiera. The hiera hash should look like this:
#
#   sendmail::virtusertable::entries:
#     'info@example.com':
#       value: 'fred'
#     '@example.org':
#       value: 'barney'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'sendmail::virtusertable': }
#
#   class { 'sendmail::virtusertable':
#     source => 'puppet:///modules/sendmail/virtusertable',
#   }
#
#
class sendmail::virtusertable (
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

    class { 'sendmail::virtusertable::file':
      content => $content,
      source  => $source,
    }
  }
  elsif !empty($entries) {
    validate_hash($entries)

    create_resources('sendmail::virtusertable::entry', $entries)
  }
}
