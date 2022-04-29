# @summary Manage the Sendmail domaintable db file.
#
# The class manages the file either as a single file resource or each entry
# in the file separately.  The file is managed as a whole using the `source`
# or `content` parameters.  The `entries` parameter is used to manage each
# entry separately. Preferable this is done with hiera using automatic
# parameter lookup.
#
# @example Manage the domaintable using hiera
#   class { 'sendmail::domaintable': }
#
# @example Manage the domaintable using the given file
#   class { 'sendmail::domaintable':
#     source => 'puppet:///modules/sendmail/domaintable',
#   }
#
# @param content The desired contents of the domaintable file.  This allows
#   managing the domaintable file as a whole.  Changes to the file
#   automatically triggers a rebuild of the domaintable database file.  This
#   attribute is mutually exclusive with `source` and `entries`.
#
# @param source A source file for the domaintable file.  This allows managing
#   the domaintable file as a whole.  Changes to the file automatically
#   triggers a rebuild of the domaintable database file.  This attribute is
#   mutually exclusive with `content` and `entries`.
#
# @param entries A hash that will be used to create
#   `sendmail::domaintable::entry` resources.  This class can be used to
#   create domaintable entries defined in hiera.  The hiera hash should look
#   like this:
#
#   sendmail::domaintable::entries:
#     'example.com':
#       value: 'example.org'
#     'example.net':
#       value: 'example.org'
#
#
class sendmail::domaintable (
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

    class { 'sendmail::domaintable::file':
      content => $content,
      source  => $source,
    }
  }
  elsif !empty($entries) {
    $entries.each |$entry,$attributes| {
      sendmail::domaintable::entry { $entry:
        * => $attributes,
      }
    }
  }
}
