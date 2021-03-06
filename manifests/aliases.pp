# = Class: sendmail::aliases
#
# Manage the Sendmail aliases file.
#
# == Parameters:
#
# [*content*]
#   The desired contents of the aliases file. This allows managing the
#   aliases file as a whole. Changes to the file automatically triggers a
#   rebuild of the aliases database file. This attribute is mutually
#   exclusive with 'source'.
#
# [*source*]
#   A source file for the aliases file. This allows managing the aliases file
#   as a whole. Changes to the file automatically triggers a rebuild of the
#   aliases database file. This attribute is mutually exclusive with
#   'content'.
#
# [*entries*]
#   A hash that will be used to create sendmail::aliases::entry resources.
#   The class can be used to create aliases defined in hiera. The hiera hash
#   should look like this:
#
#   sendmail::aliases::entries:
#     'fred':
#       recipient: 'barney@example.org'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'sendmail::aliases': }
#
#   class { 'sendmail::aliases':
#     source => 'puppet:///modules/sendmail/aliases',
#   }
#
#
class sendmail::aliases (
  Optional[String]  $content = undef,
  Optional[String]  $source  = undef,
  Hash[String,Data] $entries = {},
) {

  if ($content and $source) {
    fail('You cannot specify more than one of content, source, entries')
  }

  if ($content or $source) {
    if !empty($entries) {
      fail('You cannot specify more than one of content, source, entries')
    }

    class { 'sendmail::aliases::file':
      content => $content,
      source  => $source,
    }
  }
  elsif !empty($entries) {
    $entries.each |$entry,$attributes| {
      sendmail::aliases::entry { $entry:
        * => $attributes,
      }
    }
  }
}
