# @summary Manage the submit.mc file for the Sendmail submission program.
#
# On FreeBSD the submit configuration file is named after the hostname of the
# server. In this case the class also manages a symbolic link in `/etc/mail`
# to reference the file.
#
# @api private
#
# @param ostype The value for the `OSTYPE` macro in the `submit.mc` file.
#   The default is operating system specific.
#
# @param submit_mc_domain The name of the m4 file that holds common data for
#   a domain.  This is an optional configuration item.  It may be used by
#   large sites to gather shared data into one file.  Some Linux
#   distributions (e.g. Debian) use this setting to provide defaults for
#   certain features.  The default is operating system specific.
#
# @param msp_host The host where the message submission program should
#   deliver to.  This can be a hostname or IP address.  To prevent MX lookups
#   for the host, put it in square brackets (e.g., [hostname]). Delivery to
#   the local host would therefore use either `[127.0.0.1]` for IPv4 or
#   `[IPv6:::1]` for IPv6.
#
# @param msp_port The port used for the message submission program.  Can be
#   a port number (e.g., `25`) or the literal `MSA` for delivery to the
#   message submission agent on port 587.
#
# @param enable_msp_trusted_users Whether the trusted users file feature is
#   enabled for the message submission program.  This may be necessary if you
#   want to allow certain users to change the sender address using `sendmail
#   -f`.  Valid options: `true` or `false`.
#
# @param masquerade_as Activate masquerading for the message submission
#   program.
#
#
class sendmail::submit (
  Optional[String]            $ostype                   = $sendmail::params::submit_mc_ostype,
  Optional[String]            $submit_mc_domain         = $sendmail::params::submit_mc_domain,
  String                      $msp_host                 = '[127.0.0.1]',
  Pattern[/^(MSA)|([0-9]+)$/] $msp_port                 = 'MSA',
  Boolean                     $enable_msp_trusted_users = false,
  Optional[String]            $masquerade_as            = undef,
) inherits sendmail::params {
  include sendmail::makeall

  $params = {
    'ostype'                   => $ostype,
    'submit_mc_domain'         => $submit_mc_domain,
    'masquerade_as'            => $masquerade_as,
    'enable_msp_trusted_users' => $enable_msp_trusted_users,
    'msp_host'                 => $msp_host,
    'msp_port'                 => $msp_port,
  }

  file { $sendmail::params::submit_mc_file:
    ensure  => file,
    owner   => 'root',
    group   => $sendmail::params::sendmail_group,
    mode    => '0644',
    content => epp('sendmail/submit.m4', $params),
    notify  => [Class['sendmail::makeall'], Class['sendmail::service'],],
  }

  if ($facts['os']['family'] == 'FreeBSD') {
    # FreeBSD uses a sendmail.mc file named after the hostname of the
    # machine. Unfortunately Puppet doesn't know, if
    # $facts[networking][hostname] or $facts[networking][[fqdn] will be the
    # correct fact to determine the file name that the makefile expects (the
    # hostname command is used by the makefile). Therefore we use a symbolic
    # link here to create the second alternative.

    file { "${sendmail::params::mail_settings_dir}/${facts[networking][fqdn]}.submit.mc":
      ensure => link,
      target => "${facts[networking][hostname]}.submit.mc",
      before => File[$sendmail::params::submit_mc_file],
    }
  }
}
