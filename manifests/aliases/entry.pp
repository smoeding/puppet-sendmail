# @summary Manage an entry in the Sendmail alias file.
#
# @example Add a local alias for `fred`
#   sendmail::aliases::entry { 'fred':
#     recipient => 'barney@example.org',
#   }
#
# @param alias_name The name of the alias to create.
#
# @param ensure Used to create or remove the alias entry.  Valid options:
#   `present`, `absent`.
#
# @param recipient The recipient where the mail is redirected to.  This can
#   be a string for one recipient or an array of strings for multiple
#   recipients.
#
#
define sendmail::aliases::entry (
  String                                  $alias_name = $name,
  Enum['present','absent']                $ensure     = 'present',
  Optional[Variant[String,Array[String]]] $recipient  = undef,
) {
  include sendmail::params
  include sendmail::aliases::file
  include sendmail::aliases::newaliases

  if ($ensure == 'present' and empty($recipient)) {
    fail('recipient must be set when creating an alias')
  }

  mailalias { $alias_name:
    ensure    => $ensure,
    recipient => $recipient,
    notify    => Class['sendmail::aliases::newaliases'],
    require   => Class['sendmail::aliases::file'],
  }
}
