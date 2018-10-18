# = Define: sendmail::mc::masquerade_as
#
# Add the MASQUERADE_AS macro to the sendmail.mc file.
#
# == Parameters:
#
# [*masquerade_as*]
#   Mail being sent is rewritten as coming from the indicated address.
#   Default is the resource title.
#
# [*masquerade_domain*]
#   Normally masquerading only rewrites mail from the local host. This
#   parameter sets a set of domain or host names that is used for
#   masquerading. Default value: '[]'
#
# [*masquerade_domain_file*]
#   The set of domain or host names to be used for masquerading can also be
#   read from the file given here. Default value: 'undef'
#
# [*masquerade_exception*]
#   This parameter can set exceptions if not all hosts or subdomains for a
#   given domain should be rewritten. Default value: '[]'
#
# [*masquerade_exception_file*]
#   The exceptions can also be read from the file given here. Default value:
#   'undef'
#
# [*masquerade_envelope*]
#   Normally only header addresses are used for masquerading. By setting this
#   parameter to 'true', also envelope addresses are rewritten. Default
#   value: 'false'
#
# [*allmasquerade*]
#   Enable the 'allmasquerade' feature if set to 'true'. Default value:
#   'false'
#
# [*limited_masquerade*]
#   Enable the 'limited_masquerade' feature if set to 'true'. Default value:
#   'false'
#
# [*local_no_masquerade*]
#   Enable the 'local_no_masquerade' feature if set to 'true'. Default value:
#   'false'
#
# [*masquerade_entire_domain*]
#   Enable the 'masquerade_entire_domain' feature if set to 'true'. Default
#   value: 'false'
#
# [*exposed_user*]
#   An array of usernames that should not be masqueraded. This may be useful
#   for system users ('root' has been exposed by default prior to Sendmail
#   8.10). Default value: '[]'
#
# [*exposed_user_file*]
#   The usernames that should not be masqueraded can also be read from the
#   file given here. Default value: 'undef'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::mc::masquerade_as { 'example.com':
#     masquerade_envelope => true,
#   }
#
#
define sendmail::mc::masquerade_as (
  String                         $masquerade_as             = $title,
  Array[String]                  $masquerade_domain         = [],
  Optional[Stdlib::Absolutepath] $masquerade_domain_file    = undef,
  Array[String]                  $masquerade_exception      = [],
  Optional[Stdlib::Absolutepath] $masquerade_exception_file = undef,
  Boolean                        $masquerade_envelope       = false,
  Boolean                        $allmasquerade             = false,
  Boolean                        $limited_masquerade        = false,
  Boolean                        $local_no_masquerade       = false,
  Boolean                        $masquerade_entire_domain  = false,
  Array[String]                  $exposed_user              = [],
  Optional[Stdlib::Absolutepath] $exposed_user_file         = undef,
) {
  include ::sendmail::makeall

  concat::fragment { 'sendmail_mc-masquerade':
    target  => 'sendmail.mc',
    order   => '30',
    content => template('sendmail/masquerade.m4.erb'),
    notify  => Class['::sendmail::makeall'],
  }
}
