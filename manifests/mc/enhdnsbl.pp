# @summary Manage enhanced DNS blacklist entries
#
# @example Include the DNS blacklist `dialups.mail-abuse.org`
#   sendmail::mc::enhdnsbl { 'dialups.mail-abuse.org':
#     reject_message          => '"550 dial-up site refused"',
#     allow_temporary_failure => true,
#     lookup_result           => '127.0.0.3.',
#   }
#
# @param blacklist The DNS name to query the blacklist.
#
# @param allow_temporary_failure Determine what happens when a temporary
#   failure of the DNS lookup occurs.  The message is accepted when this
#   parameter is set to `false`.  A temporary error is signaled when this is
#   set to `true`.
#
# @param reject_message The error message used when rejecting a message.
#
# @param lookup_result Check the DNS lookup for this result.  Leave this
#   parameter unset to block the message as long as anything is returned from
#   the lookup.
#
#
define sendmail::mc::enhdnsbl (
  String           $blacklist               = $name,
  Boolean          $allow_temporary_failure = false,
  Optional[String] $reject_message          = undef,
  Optional[String] $lookup_result           = undef,
) {
  include sendmail::mc::enhdnsbl_section

  $args_array = [
    "`enhdnsbl'",
    "`${blacklist}'",
    $reject_message ? { undef => '', default => "`${reject_message}'" },
    bool2str($allow_temporary_failure, "`t'", ''),
    $lookup_result ? { undef => '', default => "`${lookup_result}'" },
  ]

  # Join array to string and remove trailing empty parameters
  $args = regsubst(join($args_array, ', '), '[, ]+$', '')

  concat::fragment { "sendmail_mc-enhdnsbl_${blacklist}":
    target  => 'sendmail.mc',
    order   => '51',
    content => "FEATURE(${args})dnl\n",
  }
}
