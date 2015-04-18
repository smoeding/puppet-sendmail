# = Class: sendmail::mailertable
#
# Create entries in the Sendmail mailertable db file.
#
# == Parameters:
#
# [*entries*]
#   A hash that will be used to create sendmail::mailertable::entry
#   resources.
#   This class can be used to create mailertable entries defined in hiera.
#   The hiera hash should look like this:
#
#   sendmail::mailertable::entries:
#     '.example.com':
#       value: 'smtp:relay.example.com'
#     'www.example.org':
#       value: 'relay:relay.example.com'
#     '.example.net':
#       value: 'error:5.7.0:550 mail is not accepted'
#   }
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   include ::sendmail::mailertable
#
#
class sendmail::mailertable (
  $entries = {},
) {

  if !empty($entries) {
    validate_hash($entries)

    create_resources('sendmail::mailertable::entry', $entries)
  }
}
