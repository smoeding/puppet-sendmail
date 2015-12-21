# = Class: sendmail::genericstable
#
# Manage the Sendmail genericstable db file.
#
# == Parameters:
#
# [*content*]
#   The desired contents of the genericstable file. This allows managing the
#   genericstable file as a whole. Changes to the file automatically triggers
#   a rebuild of the genericstable database file. This attribute is mutually
#   exclusive with 'source'.
#
# [*source*]
#   A source file for the genericstable file. This allows managing the
#   genericstable file as a whole. Changes to the file automatically triggers
#   a rebuild of the genericstable database file. This attribute is mutually
#   exclusive with 'content'.
#
# [*entries*]
#   A hash that will be used to create sendmail::genericstable::entry
#   resources. This class can be used to create genericstable entries defined
#   in hiera. The hiera hash should look like this:
#
#   sendmail::genericstable::entries:
#     'fred@example.com':
#       value: 'fred@example.org'
#     'barney':
#       value: 'barney@example.org'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'sendmail::genericstable': }
#
#   class { 'sendmail::genericstable':
#     source => 'puppet:///modules/sendmail/genericstable',
#   }
#
#
class sendmail::genericstable (
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

    class { 'sendmail::genericstable::file':
      content => $content,
      source  => $source,
    }
  }
  elsif !empty($entries) {
    validate_hash($entries)
    create_resources('sendmail::genericstable::entry', $entries)
  }
}
