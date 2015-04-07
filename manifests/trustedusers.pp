# = Class: sendmail::trustedusers
#
# Create entries in the Sendmail trusted-users file.
#
# == Parameters:
#
# [*entries*]
#   A hash that will be used to create sendmail::trustedusers::entry
#   resources.
#   This class can be used to create trusted-users defined in hiera.
#   The hiera hash should look like this:
#
#   sendmail::trustedusers::entries:
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
#   include ::sendmail::trustedusers
#
#
class sendmail::trustedusers (
  $entries = {},
) {

  if !empty($entries) {
    validate_hash($entries)

    create_resources('sendmail::trustedusers::entry', $entries)
  }
}
