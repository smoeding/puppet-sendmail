# = Class: sendmail::relaydomains
#
# Create entries in the Sendmail relay-domains file.
#
# == Parameters:
#
# [*entries*]
#   A hash that will be used to create sendmail::relaydomains::entry resources.
#   This class can be used to create trusted users defined in hiera. The hiera
#   hash should look like this:
#
#   sendmail::relaydomains::entries:
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
#   include ::sendmail::relaydomains
#
#
class sendmail::relaydomains (
  $entries = {},
) {

  if !empty($entries) {
    validate_hash($entries)

    create_resources('sendmail::relaydomains::entry', $entries)
  }
}
