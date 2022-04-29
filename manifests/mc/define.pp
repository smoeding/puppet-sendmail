# @summary Add m4 macro defines to the sendmail.mc file.
#
# @example Set a configuration item using m4 quotes
#   sendmail::mc::define { 'confFOO':
#     expansion  => 'foo',
#   }
#
# @example Set a configuration item without m4 quotes
#   sendmail::mc::define { 'confBAR':
#     expansion  => 'foo',
#     use_quotes => false,
#   }
#
# @param macro_name The name of the macro that will be defined.  This will be
#   the first argument of the m4 define builtin.  **Note**: The macro name
#   should not be quoted as it will always be quoted in the template.
#
# @param expansion The expansion defined for the macro.
#
# @param use_quotes A boolean that indicates if the expansion should be
#   quoted (using m4 quotes).  Valid options: `true` or `false`.
#
#
define sendmail::mc::define (
  String                  $macro_name = $title,
  Boolean                 $use_quotes = true,
  Variant[String,Integer] $expansion  = '',
) {
  case $macro_name {
    /^confLDAP/: {
      include sendmail::mc::define_section
      $order = '19'
    }
    /^conf(MILTER|INPUT_MAIL_FILTERS)/: {
      include sendmail::mc::milter_section
      $order = '56'
    }
    /^conf(CIPHER_LIST|CLIENT_SSL_OPTIONS|SERVER_SSL_OPTIONS)$/: {
      $order = '48'
    }
    default: {
      include sendmail::mc::define_section
      $order = '12'
    }
  }

  # Add quotes to the expansion if needed
  $exp = bool2str($use_quotes, "`${expansion}'", String($expansion))

  concat::fragment { "sendmail_mc-define-${title}":
    target  => 'sendmail.mc',
    order   => $order,
    content => "define(`${macro_name}', ${exp})dnl\n",
  }
}
