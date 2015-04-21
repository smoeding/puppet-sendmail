# = Class: sendmail::relay_domains
#
# Create entries in the Sendmail relay-domains file.
#
# == Parameters:
#
# [*entries*]
#   A hash that will be used to create sendmail::relay_domains::entry
#   resources.
#   This class can be used to create relay-domains entries defined in hiera.
#   The hiera hash should look like this:
#
#   sendmail::relay_domains::entries:
#     'example.org': {}
#     'example.com':
#       ensure: 'absent'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   include ::sendmail::relay_domains
#
#
class sendmail::relay_domains (
  $entries = {},
) {

  if !empty($entries) {
    validate_hash($entries)

    create_resources('sendmail::relay_domains::entry', $entries)
  }
}
