# @summary Add the `FEATURE` macro to the sendmail.mc file.
#
# @example Enable the `mailertable` feature
#   sendmail::mc::feature { 'mailertable': }
#
# @example Enable the `mailertable` feature using the given file location
#   sendmail::mc::feature { 'mailertable':
#     args => [ 'hash /etc/mail/mailertable' ],
#   }
#
# @example Enable the `ratecontrol` feature with an empty argument
#   sendmail::mc::feature { 'ratecontrol':
#     args => [ undef, 'terminate' ],
#   }
#
# @param feature_name The name of the feature that will be used.  This will
#   be the first argument of the `FEATURE()`.  **Note**: The feature name
#   should not be quoted as it will always be quoted in the template.
#
# @param args The arguments used for the feature.  This can be a string (one
#   argument) or an array and it will be used for the following arguments of
#   the `FEATURE()`. The array values can either be strings or a literal
#   `undef` which will skip the value in the generated argument list.
#
# @param use_quotes A boolean that indicates if the arguments should be
#   quoted (using m4 quotes).  Valid options: `true` or `false`.
#
#
define sendmail::mc::feature (
  String                                  $feature_name = $name,
  Variant[String,Array[Optional[String]]] $args         = [],
  Boolean                                 $use_quotes   = true,
) {
  include sendmail::mc::feature_section

  # Make sure arguments are really an array
  $args_array = $args ? {
    Array   => $args,
    default => [$args],
  }

  # Gracefully handle misspelled feature names
  $feature = $feature_name ? {
    'access' => 'access_db',
    default  => $feature_name,
  }

  # Reduce array to a comma separated string argument
  $arg = $args_array.reduce("`${feature}'") |$memo, $value| {
    # Add quotes to the args if needed; skip undefined args
    $item = $value ? {
      Undef   => '',
      default => bool2str($use_quotes, "`${value}'", $value)
    }

    "${memo}, ${item}"
  }

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
