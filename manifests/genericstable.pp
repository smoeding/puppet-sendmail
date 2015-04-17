# = Class: sendmail::genericstable
#
# Create entries in the Sendmail genericstable db file.
#
# == Parameters:
#
# [*entries*]
#   A hash that will be used to create sendmail::genericstable::entry
#   resources.
#   This class can be used to create genericstable entries defined in hiera.
#   The hiera hash should look like this:
#
#   sendmail::genericstable::entries:
#     'fred@example.com':
#       value: 'fred@example.org'
#     'barney':
#       value: 'barney@example.org'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   include ::sendmail::genericstable
#
#
class sendmail::genericstable (
  $entries = {},
) {

  if !empty($entries) {
    validate_hash($entries)

    create_resources('sendmail::genericstable::entry', $entries)
  }
}
