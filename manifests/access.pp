# = Class: sendmail::access
#
# Create entries in the Sendmail access db file.
#
# == Parameters:
#
# [*entries*]
#   A hash that will be used to create sendmail::access::entry
#   resources.
#   This class can be used to create access entries defined in hiera.
#   The hiera hash should look like this:
#
#   sendmail::access::entries:
#     'example.com':
#       value: 'OK'
#     'example.org':
#       value: 'REJECT'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   include ::sendmail::access
#
#
class sendmail::access (
  $entries = {},
) {

  if !empty($entries) {
    validate_hash($entries)

    create_resources('sendmail::access::entry', $entries)
  }
}
