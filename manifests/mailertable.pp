# @summary Manage the Sendmail mailertable db file.
#
# The class manages the file either as a single file resource or each entry
# in the file separately.  The file is managed as a whole using the `source`
# or `content` parameters.  The `entries` parameter is used to manage each
# entry separately. Preferable this is done with hiera using automatic
# parameter lookup.
#
# @example Manage the mailertable using hiera
#   class { 'sendmail::mailertable': }
#
# @example Manage the mailertable using the provided file
#   class { 'sendmail::mailertable':
#     source => 'puppet:///modules/sendmail/mailertable',
#   }
#
# @param content The desired contents of the mailertable file.  This allows
#   managing the mailertable file as a whole.  Changes to the file
#   automatically triggers a rebuild of the mailertable database file.  This
#   attribute is mutually exclusive with `source` and `entries`.
#
# @param source A source file for the mailertable file.  This allows managing
#   the mailertable file as a whole.  Changes to the file automatically
#   triggers a rebuild of the mailertable database file.  This attribute is
#   mutually exclusive with `content` and `entries`.
#
# @param entries A hash that will be used to create
#   `sendmail::mailertable::entry` resources.  This class can be used to
#   create mailertable entries defined in hiera.  The hiera hash should look
#   like this:
#
#   ```yaml
#   sendmail::mailertable::entries:
#     '.example.com':
#       value: 'smtp:relay.example.com'
#     'www.example.org':
#       value: 'relay:relay.example.com'
#     '.example.net':
#       value: 'error:5.7.0:550 mail is not accepted'
#   ```
#
#
class sendmail::mailertable (
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

    class { 'sendmail::mailertable::file':
      content => $content,
      source  => $source,
    }
  }
  elsif !empty($entries) {
    $entries.each |$entry,$attributes| {
      sendmail::mailertable::entry { $entry:
        * => $attributes,
      }
    }
  }
}
