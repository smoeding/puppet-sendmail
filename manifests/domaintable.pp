# = Class: sendmail::domaintable
#
# Create entries in the Sendmail domaintable db file.
#
# == Parameters:
#
# [*entries*]
#   A hash that will be used to create sendmail::domaintable::entry
#   resources.
#   This class can be used to create domaintable entries defined in hiera.
#   The hiera hash should look like this:
#
#   sendmail::domaintable::entries:
#     'example.com':
#       value: 'example.org'
#     'example.net':
#       value: 'example.org'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   include ::sendmail::domaintable
#
#
class sendmail::domaintable (
  $entries = {},
) {

  if !empty($entries) {
    validate_hash($entries)

    create_resources('sendmail::domaintable::entry', $entries)
  }
}
