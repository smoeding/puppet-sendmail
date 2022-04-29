# @summary Manage the Sendmail access db file.
#
# The class manages the file either as a single file resource or each entry
# in the file separately.  The file is managed as a whole using the `source`
# or `content` parameters.  The `entries` parameter is used to manage each
# entry separately. Preferable this is done with hiera using automatic
# parameter lookup.
#
# This class is only used to manage the access db file. You will also need to
# enable the `access_db` feature using `sendmail::mc::feature` to tell
# Sendmail to actually use the file.
#
# @example Manage the access database using hiera
#   class { 'sendmail::access': }
#
# @example Manage the access database using the given file
#   class { 'sendmail::access':
#     source => 'puppet:///modules/sendmail/access',
#   }
#
# @param content The desired contents of the access file.  This allows
#   managing the access file as a whole.  Changes to the file automatically
#   triggers a rebuild of the access database file.  This attribute is
#   mutually exclusive with `source` and `entries`.
#
# @param source A source file for the access file.  This allows managing the
#   access file as a whole.  Changes to the file automatically triggers
#   a rebuild of the access database file.  This attribute is mutually
#   exclusive with `content` and `entries`.
#
# @param entries A hash that will be used to create `sendmail::access::entry`
#   resources.  The class can be used to create access entries defined in
#   hiera.  The hiera hash should look like this:
#
#   sendmail::access::entries:
#     'example.com':
#       value: 'OK'
#     'example.org':
#       value: 'REJECT'
#
#
class sendmail::access (
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

    class { 'sendmail::access::file':
      content => $content,
      source  => $source,
    }
  }
  elsif !empty($entries) {
    $entries.each |$entry,$attributes| {
      sendmail::access::entry { $entry:
        * => $attributes,
      }
    }
  }
}
