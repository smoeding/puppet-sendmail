# = Define: sendmail::mc::define
#
# Add m4 macro defines to the sendmail.mc file.
#
# == Parameters:
#
# [*macro_name*]
#   The name of the macro that will be defined. This will be the first
#   argument of the m4 define builtin.
#   **Note**: The macro name should not be quoted as it will always be
#   quoted in the template.
#
# [*expansion*]
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
#   sendmail::mc::define { 'confFOO':
#     expansion  => 'foo',
#   }
#
#   sendmail::mc::define { 'confBAR':
#     expansion  => 'foo',
#     use_quotes => false,
#   }
#
#
define sendmail::mc::define (
  String                  $macro_name = $title,
  Boolean                 $use_quotes = true,
  Variant[String,Integer] $expansion  = '',
) {
  include ::sendmail::makeall

  case $macro_name {
    /^confLDAP/: {
      include ::sendmail::mc::define_section
      $order = '19'
    }
    /^conf(MILTER|INPUT_MAIL_FILTERS)/: {
      include ::sendmail::mc::milter_section
      $order = '56'
    }
    /^conf(CIPHER_LIST|CLIENT_SSL_OPTIONS|SERVER_SSL_OPTIONS)$/: {
      $order = '48'
    }
    default: {
      include ::sendmail::mc::define_section
      $order = '12'
    }
  }

  # Add quotes to the expansion if needed
  $exp = bool2str($use_quotes, "`${expansion}'", String($expansion))

  concat::fragment { "sendmail_mc-define-${title}":
    target  => 'sendmail.mc',
    order   => $order,
    content => "define(`${macro_name}', ${exp})dnl\n",
    notify  => Class['::sendmail::makeall'],
  }
}
