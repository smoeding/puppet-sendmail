# @summary Add the `MASQUERADE_AS` macro to the sendmail.mc file.
#
# @example Masquerade as `example.com` including envelope adresses
#   sendmail::mc::masquerade_as { 'example.com':
#     masquerade_envelope => true,
#   }
#
# @param masquerade_as Mail being sent is rewritten as coming from the
#   indicated address.
#
# @param masquerade_domain Normally masquerading only rewrites mail from the
#   local host.  This parameter sets a set of domain or host names that is
#   used for masquerading.
#
# @param masquerade_domain_file The set of domain or host names to be used
#   for masquerading can also be read from the file given here.
#
# @param masquerade_exception This parameter can set exceptions if not all
#   hosts or subdomains for a given domain should be rewritten.
#
# @param masquerade_exception_file The exceptions can also be read from the
#   file given here.
#
# @param masquerade_envelope Normally only header addresses are used for
#   masquerading.  By setting this parameter to `true`, also envelope
#   addresses are rewritten.
#
# @param allmasquerade Enable the `allmasquerade` feature if set to
#   `true`.
#
# @param limited_masquerade Enable the `limited_masquerade` feature if set to
#   `true`.
#
# @param local_no_masquerade Enable the `local_no_masquerade` feature if set
#   to `true`.
#
# @param masquerade_entire_domain Enable the `masquerade_entire_domain`
#   feature if set to `true`.
#
# @param exposed_user An array of usernames that should not be masqueraded.
#   This may be useful for system users (`root` has been exposed by default
#   prior to Sendmail 8.10).
#
# @param exposed_user_file The usernames that should not be masqueraded can
#   also be read from the file given here.
#
#
define sendmail::mc::masquerade_as (
  String                         $masquerade_as             = $name,
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
  $params = {
    'masquerade_as'             => $masquerade_as,
    'masquerade_domain'         => $masquerade_domain,
    'masquerade_domain_file'    => $masquerade_domain_file,
    'masquerade_exception'      => $masquerade_exception,
    'masquerade_exception_file' => $masquerade_exception_file,
    'exposed_user'              => $exposed_user,
    'exposed_user_file'         => $exposed_user_file,
    'masquerade_envelope'       => $masquerade_envelope,
    'allmasquerade'             => $allmasquerade,
    'limited_masquerade'        => $limited_masquerade,
    'local_no_masquerade'       => $local_no_masquerade,
    'masquerade_entire_domain'  => $masquerade_entire_domain,
  }

  concat::fragment { 'sendmail_mc-masquerade':
    target  => 'sendmail.mc',
    order   => '30',
    content => epp('sendmail/masquerade.m4', $params),
  }
}
