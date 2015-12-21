# = Class: sendmail::domaintable
#
# Manage the Sendmail domaintable db file.
#
# == Parameters:
#
# [*content*]
#   The desired contents of the domaintable file. This allows managing the
#   domaintable file as a whole. Changes to the file automatically triggers a
#   rebuild of the domaintable database file. This attribute is mutually
#   exclusive with 'source'.
#
# [*source*]
#   A source file for the domaintable file. This allows managing the
#   domaintable file as a whole. Changes to the file automatically triggers a
#   rebuild of the domaintable database file. This attribute is mutually
#   exclusive with 'content'.
#
# [*entries*]
#   A hash that will be used to create sendmail::domaintable::entry
#   resources. This class can be used to create domaintable entries defined
#   in hiera. The hiera hash should look like this:
#
#   sendmail::domaintable::entries:
#     'example.com':
#       value: 'example.org'
#     'example.net':
#       value: 'example.org'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'sendmail::domaintable': }
#
#   class { 'sendmail::domaintable':
#     source => 'puppet:///modules/sendmail/domaintable',
#   }
#
#
class sendmail::domaintable (
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

    class { 'sendmail::domaintable::file':
      content => $content,
      source  => $source,
    }
  }
  elsif !empty($entries) {
    validate_hash($entries)
    create_resources('sendmail::domaintable::entry', $entries)
  }
}
