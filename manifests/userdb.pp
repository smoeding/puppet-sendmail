# @summary Manage the Sendmail userdb db file.
#
# The class manages the file either as a single file resource or each entry
# in the file separately.  The file is managed as a whole using the `source`
# or `content` parameters.  The `entries` parameter is used to manage each
# entry separately. Preferable this is done with hiera using automatic
# parameter lookup.
#
# @example Manage the userdb using hiera
#   class { 'sendmail::userdb': }
#
# @example Manage the userdb using the provided file
#   class { 'sendmail::userdb':
#     source => 'puppet:///modules/sendmail/userdb',
#   }
#
# @param content The desired contents of the userdb file.  This allows
#   managing the userdb file as a whole.  Changes to the file automatically
#   triggers a rebuild of the userdb database file.  This attribute is
#   mutually exclusive with `source` and `entries`.
#
# @param source A source file for the userdb file.  This allows managing the
#   userdb file as a whole.  Changes to the file automatically triggers
#   a rebuild of the userdb database file.  This attribute is mutually
#   exclusive with `content` and `entries`.
#
# @param entries A hash that will be used to create `sendmail::userdb::entry`
#   resources.  This class can be used to create userdb entries defined in
#   hiera.  The hiera hash should look like this:
#
#   ```yaml
#   sendmail::userdb::entries:
#     'fred:maildrop':
#       value: 'fred@example.org'
#     'barney:maildrop':
#       value: 'barney@example.org'
#   ```
#
#
class sendmail::userdb (
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

    class { 'sendmail::userdb::file':
      content => $content,
      source  => $source,
    }
  }
  elsif !empty($entries) {
    $entries.each |$entry,$attributes| {
      sendmail::userdb::entry { $entry:
        * => $attributes,
      }
    }
  }
}
