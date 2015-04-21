# = Class: sendmail::trusted_users
#
# Create entries in the Sendmail trusted-users file.
#
# == Parameters:
#
# [*entries*]
#   A hash that will be used to create sendmail::trusted_users::entry
#   resources.
#   This class can be used to create trusted-users defined in hiera.
#   The hiera hash should look like this:
#
#   sendmail::trusted_users::entries:
#     'fred': {}
#     'barney':
#       ensure: 'absent'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   include ::sendmail::trusted_users
#
#
class sendmail::trusted_users (
  $entries = {},
) {

  if !empty($entries) {
    validate_hash($entries)

    create_resources('sendmail::trusted_users::entry', $entries)
  }
}
