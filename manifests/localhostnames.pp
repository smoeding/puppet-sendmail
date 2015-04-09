# = Class: sendmail::localhostnames
#
# Create entries in the Sendmail local-host-names file.
#
# == Parameters:
#
# [*entries*]
#   A hash that will be used to create sendmail::localhostnames::entry
#   resources.
#   This class can be used to set local-host-names defined in hiera.
#   The hiera hash should look like this:
#
#   sendmail::localhostnames::entries:
#     'example.org': {}
#     'www.example.org':
#       ensure: 'absent'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   include ::sendmail::localhostnames
#
#
class sendmail::localhostnames (
  $entries = {},
) {

  if !empty($entries) {
    validate_hash($entries)

    create_resources('sendmail::localhostnames::entry', $entries)
  }
}
