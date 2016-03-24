# = Class: sendmail::submit
#
# Manage the submit.mc file for the Sendmail MTA.
#
# == Parameters:
#
# [*ostype*]
#   The value for the OSTYPE macro in the submit.mc file.
#   Default value: operating system specific.
#
# [*submit_mc_domain*]
#   The name of the m4 file that holds common data for a domain. This is an
#   optional configuration item. It may be used by large sites to gather
#   shared data into one file. Some Linux distributions (e.g. Debian) use
#   this setting to provide defaults for certain features.
#   Default value: operating system specific.
#
# [*msp_host*]
#   The host where the message submission program should deliver to. This
#   can be a hostname or IP address. To prevent MX lookups for the host,
#   put it in square brackets (e.g., [hostname]). Delivery to the local
#   host would therefore use either [127.0.0.1] for IPv4 or [IPv6:::1]
#   for IPv6.
#
# [*msp_port*]
#   The port used for the message submission program. Can be a port number
#   (e.g., 25) or the literal 'MSA' for delivery to the message submission
#   agent on port 587.
#
# [*enable_msp_trusted_users*]
#   Whether the trusted users file feature is enabled for the message
#   submission program. This may be necessary if you want to allow certain
#   users to change the sender address using 'sendmail -f'. Valid options:
#   'true' or 'false'. Default value: 'false'.
#
# [*masquerade_as*]
#   Activate masquerading for the message submission program.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'sendmail::submit':
#     msp_port      => '25',
#     masquerade_as => 'example.org',
#   }
#
#
class sendmail::submit (
  $ostype                   = $::sendmail::params::submit_mc_ostype,
  $submit_mc_domain         = $::sendmail::params::submit_mc_domain,
  $msp_host                 = '[127.0.0.1]',
  $msp_port                 = 'MSA',
  $enable_msp_trusted_users = false,
  $masquerade_as            = undef,
) inherits sendmail::params {

  validate_re($msp_port, [ '^[0-9]+$', '^MSA$' ], 'msp_port must be a numeric port number or the literal "MSA"')

  validate_bool($enable_msp_trusted_users)

  file { $::sendmail::params::submit_mc_file:
    ensure  => file,
    owner   => 'root',
    group   => $sendmail::params::sendmail_group,
    mode    => '0644',
    content => template('sendmail/submit.m4.erb'),
    notify  => [ Class['::sendmail::makeall'], Class['::sendmail::service'], ],
  }

  if ($::osfamily == 'FreeBSD') {
    # FreeBSD uses a sendmail.mc file named after the hostname of the
    # machine. Unfortunately Puppet doesn't know, if $::hostname or $::fqdn
    # will be the correct fact to determine the file name that the makefile
    # expects (the hostname command is used by the makefile). Therefore we
    # use a symbolic link here to create the second alternative.

    file { "${::sendmail::params::mail_settings_dir}/${::fqdn}.submit.mc":
      ensure => link,
      target => "${::hostname}.submit.mc",
      before => File[$::sendmail::params::submit_mc_file],
    }
  }
}
