# = Define: sendmail::mc::queue_group
#
# Add m4 macro queue_group to the sendmail.mc file.
#
# == Parameters:
#
# [*queue_name*]
#   The name of the queue.
#   **Note**: The macro name should not be quoted as it will always be
#   quoted in the template.
#
# [*args*]
#   The expansion defined for the macro.
#
# [*use_quotes*]
#   A boolean that indicates if the expansion should be quoted (using
#   m4 quotes). If this argument is 'true', then the expansion will be
#   enclosed in ` and ' symbols in the generated output file.
#   **Note**: The name of the defined macro will always be quoted.
#   Valid options: 'true' or 'false'. Default value: 'true'.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::mc::queue_group { 'gmailcom':
#     args  => 'foo',
#   }
#
define sendmail::mc::queue_group (
  String  $queue_name = $title,
  Boolean $use_quotes = true,
  String  $args  = '',
) {
  # Include section
  include sendmail::mc::queue_group_section

  # Add quotes to the expansion if needed
  $exp = bool2str($use_quotes, "`${args}'", String($args))

  concat::fragment { "sendmail_mc-queue_group-${title}":
    target  => 'sendmail.mc',
    order   => 30,
    content => "QUEUE_GROUP(`${queue_name}', ${exp})dnl\n",
  }
}
