# @summary Manage the Sendmail genericstable db file.
#
# The class manages the file either as a single file resource or each entry
# in the file separately.  The file is managed as a whole using the `source`
# or `content` parameters.  The `entries` parameter is used to manage each
# entry separately. Preferable this is done with hiera using automatic
# parameter lookup.
#
# Use the `sendmail::mc::generics_domain` type to configure the domains for
# which non-local user addresses should be rewritten.
#
# @example Manage the generictable using hiera
#   class { 'sendmail::genericstable': }
#
# @example Manage the generictable using the provided file
#   class { 'sendmail::genericstable':
#     source => 'puppet:///modules/sendmail/genericstable',
#   }
#
# @param content The desired contents of the genericstable file.  This allows
#   managing the genericstable file as a whole.  Changes to the file
#   automatically triggers a rebuild of the genericstable database file.
#   This attribute is mutually exclusive with `source` and `entries`.
#
# @param source A source file for the genericstable file.  This allows
#   managing the genericstable file as a whole.  Changes to the file
#   automatically triggers a rebuild of the genericstable database file.
#   This attribute is mutually exclusive with `content` and `entries`.
#
# @param entries A hash that will be used to create
#   `sendmail::genericstable::entry` resources.  This class can be used to
#   create genericstable entries defined in hiera.  The hiera hash should
#   look like this:
#
#   sendmail::genericstable::entries:
#     'fred@example.com':
#       value: 'fred@example.org'
#     'barney':
#       value: 'barney@example.org'
#
#
class sendmail::genericstable (
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

    class { 'sendmail::genericstable::file':
      content => $content,
      source  => $source,
    }
  }
  elsif !empty($entries) {
    $entries.each |$entry,$attributes| {
      sendmail::genericstable::entry { $entry:
        * => $attributes,
      }
    }
  }
}
