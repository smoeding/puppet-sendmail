# = Class: sendmail::aliases
#
# Create entries in the Sendmail alias file.
#
# == Parameters:
#
# [*entries*]
#   A hash that will be used to create sendmail::alieses::entry resources.
#   This class can be used to create aliases defined in hiera. The hiera
#   hash should look like this:
#
#   sendmail::aliases::entries:
#     'fred':
#       recipient: 'barney@example.org'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   include ::sendmail::aliases
#
#
class sendmail::aliases (
  $entries = {},
) {

  if !empty($entries) {
    validate_hash($entries)

    create_resources('sendmail::aliases::entry', $entries)
  }
}
