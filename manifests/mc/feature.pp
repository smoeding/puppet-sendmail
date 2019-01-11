# = Define: sendmail::mc::feature
#
# Add the FEATURE macro to the sendmail.mc file.
#
# == Parameters:
#
# [*feature_name*]
#   The name of the feature that will be used. This will be the first
#   argument of the FEATURE().
#   **Note**: The feature name should not be quoted as it will always be
#   quoted in the template.
#
# [*args*]
#   The arguments used for the feature. This can be a string (one argument)
#   or and an array and it will be used for the following arguments of the
#   FEATURE().
#   Default value: []
#
# [*use_quotes*]
#   A boolean that indicates if the arguments should be quoted (using
#   m4 quotes). If this argument is 'true', then the arguments will be
#   enclosed in ` and ' symbols in the generated output file.
#   **Note**: The name of the feature will always be quoted.
#   Valid options: 'true' or 'false'. Default value: 'true'.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::mc::feature { 'mailertable': }
#
#   sendmail::mc::feature { 'mailertable':
#     args       => [ 'hash /etc/mail/mailertable' ],
#   }
#
#   sendmail::mc::feature { 'mailertable':
#     args       => [ '`hash /etc/mail/mailertable\'' ],
#     use_quotes => false,
#   }
#
#
define sendmail::mc::feature (
  String                        $feature_name = $title,
  Variant[String,Array[String]] $args         = [],
  Boolean                       $use_quotes   = true,
) {
  include sendmail::mc::feature_section

  # Make sure arguments are really an array
  $args_array = $args ? {
    Array   => $args,
    default => [ $args ],
  }

  # Gracefully handle misspelled feature names
  $feature = $feature_name ? {
    'access' => 'access_db',
    default  => $feature_name,
  }

  # Add quotes to the args if needed
  $exp_arg = $use_quotes ? {
    true  => $args_array.map |$item| { "`${item}'" },
    false => $args_array,
  }

  $arg = join(concat([ "`${feature}'" ], $exp_arg), ', ')

  $order = $feature ? {
    'ldap_routing' => '19',
    'conncontrol'  => '28',
    'ratecontrol'  => '28',
    'nullclient'   => '29',
    default        => '22',
  }

  concat::fragment { "sendmail_mc-feature-${title}":
    target  => 'sendmail.mc',
    order   => $order,
    content => "FEATURE(${arg})dnl\n",
  }
}
