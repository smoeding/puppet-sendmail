# = Class: sendmail::mailertable
#
# Manage the Sendmail mailertable db file.
#
# == Parameters:
#
# [*content*]
#   The desired contents of the mailertable file. This allows managing the
#   mailertable file as a whole. Changes to the file automatically triggers a
#   rebuild of the mailertable database file. This attribute is mutually
#   exclusive with 'source'.
#
# [*source*]
#   A source file for the mailertable file. This allows managing the
#   mailertable file as a whole. Changes to the file automatically triggers a
#   rebuild of the mailertable database file. This attribute is mutually
#   exclusive with 'content'.
#
# [*entries*]
#   A hash that will be used to create sendmail::mailertable::entry
#   resources. This class can be used to create mailertable entries defined
#   in hiera. The hiera hash should look like this:
#
#   sendmail::mailertable::entries:
#     '.example.com':
#       value: 'smtp:relay.example.com'
#     'www.example.org':
#       value: 'relay:relay.example.com'
#     '.example.net':
#       value: 'error:5.7.0:550 mail is not accepted'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'sendmail::mailertable': }
#
#   class { 'sendmail::mailertable':
#     source => 'puppet:///modules/sendmail/mailertable',
#   }
#
#
class sendmail::mailertable (
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

    class { 'sendmail::mailertable::file':
      content => $content,
      source  => $source,
    }
  }
  elsif !empty($entries) {
    validate_hash($entries)

    create_resources('sendmail::mailertable::entry', $entries)
  }
}
