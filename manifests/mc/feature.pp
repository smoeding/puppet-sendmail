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
#   The arguments used for the feature. This must be an array and it will
#   be used for the following arguments of the FEATURE().
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
#     args => [ 'hash /etc/mail/mailertable' ],
#   }
#
#   sendmail::mc::feature { 'mailertable':
#     args       => [ '`hash /etc/mail/mailertable\'' ],
#     use_quotes => false,
#   }
#
#
define sendmail::mc::feature (
  $feature_name = $title,
  $args         = [],
  $use_quotes   = true,
) {
  include ::sendmail::makeall

  validate_array($args)
  validate_bool($use_quotes)

  # Add quotes to the args if needed
  $exp_arg = $use_quotes ? {
    true  => suffix(prefix($args, '`'), '\''),
    false => $args,
  }

  $arr = concat([ "`${feature_name}'" ], $exp_arg)

  $order = $feature_name ? {
    'ldap_routing' => '19',
    'conncontrol'  => '28',
    'ratecontrol'  => '28',
    'nullclient'   => '29',
    default        => '22',
  }

  concat::fragment { "sendmail_mc-feature-${title}":
    target  => 'sendmail.mc',
    order   => $order,
    content => inline_template("FEATURE(<%= @arr.join(', ') -%>)dnl\n"),
    notify  => Class['::sendmail::makeall'],
  }

  # Also add the section header
  include ::sendmail::mc::feature_section
}
