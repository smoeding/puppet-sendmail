# = Class: sendmail::userdb
#
# Create entries in the Sendmail userdb db file.
#
# == Parameters:
#
# [*entries*]
#   A hash that will be used to create sendmail::userdb::entry
#   resources.
#   This class can be used to create userdb entries defined in hiera.
#   The hiera hash should look like this:
#
#   sendmail::userdb::entries:
#     'fred:maildrop':
#       value: 'fred@example.org'
#     'barney:maildrop':
#       value: 'barney@example.org'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   include ::sendmail::userdb
#
#
class sendmail::userdb (
  $entries = {},
) {

  if !empty($entries) {
    validate_hash($entries)

    create_resources('sendmail::userdb::entry', $entries)
  }
}
