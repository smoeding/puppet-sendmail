# = Class: sendmail::virtusertable
#
# Create entries in the Sendmail virtusertable db file.
#
# == Parameters:
#
# [*entries*]
#   A hash that will be used to create sendmail::virtusertable::entry
#   resources.
#   This class can be used to create virtusertable entries defined in hiera.
#   The hiera hash should look like this:
#
#   sendmail::virtusertable::entries:
#     'info@example.com':
#       value: 'fred'
#     '@example.org':
#       value: 'barney'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   include ::sendmail::virtusertable
#
#
class sendmail::virtusertable (
  $entries = {},
) {

  if !empty($entries) {
    validate_hash($entries)

    create_resources('sendmail::virtusertable::entry', $entries)
  }
}
