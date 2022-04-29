# @summary Manage the Sendmail aliases file.
#
# The class manages the file either as a single file resource or each entry
# in the file separately.  The file is managed as a whole using the `source`
# or `content` parameters.  The `entries` parameter is used to manage each
# entry separately. Preferable this is done with hiera using automatic
# parameter lookup.
#
#
# @example Set up aliases using a configuration from hiera
#   class { 'sendmail::aliases': }
#
# @example Set up aliases using the given file
#   class { 'sendmail::aliases':
#     source => 'puppet:///modules/sendmail/aliases',
#   }
#
# @param content The desired contents of the aliases file.  This allows
#   managing the aliases file as a whole.  Changes to the file automatically
#   triggers a rebuild of the aliases database file.  This attribute is
#   mutually exclusive with `source` and `entries`.
#
# @param source A source file for the aliases file.  This allows managing the
#   aliases file as a whole.  Changes to the file automatically triggers
#   a rebuild of the aliases database file.  This attribute is mutually
#   exclusive with `content` and `entries`.
#
# @param entries A hash that will be used to create sendmail::aliases::entry
#   resources.  This attribute is mutually exclusive with `content` and
#   `source`. The class can be used to create aliases defined in hiera.
#   The hiera hash should look like this:
#
#   sendmail::aliases::entries:
#     'fred':
#       recipient: 'barney@example.org'
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
