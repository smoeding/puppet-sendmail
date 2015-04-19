# = Class: sendmail::authinfo
#
# Create entries in the Sendmail authinfo db file.
#
# == Parameters:
#
# [*entries*]
#   A hash that will be used to create sendmail::authinfo::entry
#   resources.
#   This class can be used to create authinfo entries defined in hiera.
#   The hiera hash should look like this:
#
#   sendmail::authinfo::entries:
#     'AuthInfo:example.com':
#       value: '"U=auth" "P=secret"'
#     'AuthInfo:192.168.67.89':
#       value: '"U=fred" "P=wilma"'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   include ::sendmail::authinfo
#
#
class sendmail::authinfo (
  $entries = {},
) {

  if !empty($entries) {
    validate_hash($entries)

    create_resources('sendmail::authinfo::entry', $entries)
  }
}
