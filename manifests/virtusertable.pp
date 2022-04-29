# @summary Manage the Sendmail virtusertable db file.
#
# The class manages the file either as a single file resource or each entry
# in the file separately.  The file is managed as a whole using the `source`
# or `content` parameters.  The `entries` parameter is used to manage each
# entry separately. Preferable this is done with hiera using automatic
# parameter lookup.
#
# @example Manage the virtusertable using hiera
#   class { 'sendmail::virtusertable': }
#
# @example Manage the virtusertable using the provided file
#   class { 'sendmail::virtusertable':
#     source => 'puppet:///modules/sendmail/virtusertable',
#   }
#
# @param content The desired contents of the virtusertable file.  This allows
#   managing the virtusertable file as a whole.  Changes to the file
#   automatically triggers a rebuild of the virtusertable database file.
#   This attribute is mutually exclusive with 'source' and `entries`.
#
# @param source A source file for the virtusertable file.  This allows
#   managing the virtusertable file as a whole.  Changes to the file
#   automatically triggers a rebuild of the virtusertable database file.
#   This attribute is mutually exclusive with 'content' and `entries`.
#
# @param entries A hash that will be used to create
#   `sendmail::virtusertable::entry` resources.  This class can be used to
#   create virtusertable entries defined in hiera.  The hiera hash should
#   look like this:
#
#   sendmail::virtusertable::entries:
#     'info@example.com':
#       value: 'fred'
#     '@example.org':
#       value: 'barney'
#
#
class sendmail::virtusertable (
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

    class { 'sendmail::virtusertable::file':
      content => $content,
      source  => $source,
    }
  }
  elsif !empty($entries) {
    $entries.each |$entry,$attributes| {
      sendmail::virtusertable::entry { $entry:
        * => $attributes,
      }
    }
  }
}
