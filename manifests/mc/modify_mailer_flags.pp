# = Define: sendmail::mc::modify_mailer_flags
#
# Add a MODIFY_MAILER_FLAGS macro to the sendmail.mc file.
#
# == Parameters:
#
# [*mailer_name*]
#   The name of the mailer for which the flags will be changed. This name is
#   case-sensitive and must conform to the name of the mailer. Usually this
#   will be a name in uppercase (e.g. 'SMTP' or 'LOCAL'). Defaults to the
#   resource title.
#
# [*flags*]
#   The flags to change. Adding single flags is possible by prefixing the
#   flag with a '+' symbol. Removing single flags from the mailer can be done
#   with a '-' symbol as prefix. Without a leading '+' or '-' the flags will
#   replace the flags of the delivery agent.
#
# [*use_quotes*]
#   A boolean that indicates if the flags should be quoted (using m4 quotes).
#   If this argument is 'true', then the flags will be enclosed in ` and '
#   symbols in the generated output file. Valid options: 'true' or 'false'.
#   Default value: 'true'.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::mc::modify_mailer_flags { 'SMTP':
#     flags => '+O',
#   }
#
#
define sendmail::mc::modify_mailer_flags (
  String  $flags,
  String  $mailer_name = $title,
  Boolean $use_quotes  = true,
) {
  include sendmail::mc::macro_section

  # Add quotes to the expansion if needed
  $exp_arg = bool2str($use_quotes, "`${flags}'", $flags)

  $arg = join([ "`${mailer_name}'", $exp_arg ], ', ')

  concat::fragment { "sendmail_mc-modify_mailer_flags-${title}":
    target  => 'sendmail.mc',
    order   => '38',
    content => "MODIFY_MAILER_FLAGS(${arg})dnl\n",
  }
}
