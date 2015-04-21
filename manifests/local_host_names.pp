# = Class: sendmail::local_host_names
#
# Create entries in the Sendmail local-host-names file.
#
# == Parameters:
#
# [*entries*]
#   A hash that will be used to create sendmail::local_host_names::entry
#   resources.
#   This class can be used to set local-host-names defined in hiera.
#   The hiera hash should look like this:
#
#   sendmail::local_host_names::entries:
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
#   include ::sendmail::local_host_names
#
#
class sendmail::local_host_names (
  $entries = {},
) {

  if !empty($entries) {
    validate_hash($entries)

    create_resources('sendmail::local_host_names::entry', $entries)
  }
}
