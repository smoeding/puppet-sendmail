# = Class: sendmail::mc
#
# Manage the sendmail.mc file
#
# == Parameters:
#
# [*ostype*]
#   The value for the OSTYPE macro in the sendmail.mc file.
#   Default value: operating system specific.
#
# [*sendmail_mc_domain*]
#   The name of the m4 file that holds common data for a domain. This is an
#   optional configuration item. It may be used by large sites to gather
#   shared data into one file. Some Linux distributions (e.g. Debian) use
#   this setting to provide defaults for certain features.
#   Default value: operating system specific.
#
# [*smart_host*]
#   Servers that are behind a firewall may not be able to deliver mail
#   directly to the outside world. In this case the host may need to forward
#   the mail to the gateway machine defined by this parameter. All nonlocal
#   mail is forwarded to this gateway.
#   Default value: none.
#
# [*log_level*]
#   The loglevel for the sendmail process.
#   Valid options: a numeric value. Default value: none.
#
# [*dont_probe_interfaces*]
#   Sendmail normally probes all network interfaces to get the hostnames that
#   the server may have. These hostnames are then considered local. This
#   option can be used to prevent the reverse lookup of the network addresses.
#   If this option is set to 'localhost' then all network interfaces except
#   for the loopback interface is probed.
#   Valid options: the strings 'true', 'false' or 'localhost'.
#   Default value: none.
#
# [*enable_ipv4_daemon*]
#   Should the host accept mail on all IPv4 network adresses.
#   Valid options: 'true' or 'false'. Default value: 'true'.
#
# [*enable_ipv6_daemon*]
#   Should the host accept mail on all IPv6 network adresses.
#   Valid options: 'true' or 'false'. Default value: 'true'.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { '::sendmail::mc': }
#
#
class sendmail::mc (
  $ostype                = $::sendmail::params::ostype,
  $sendmail_mc_domain    = $::sendmail::params::sendmail_mc_domain,
  $smart_host            = undef,
  $log_level             = undef,
  $max_message_size      = undef,
  $dont_probe_interfaces = undef,
  $enable_ipv4_daemon    = true,
  $enable_ipv6_daemon    = true,
) inherits ::sendmail::params {

  include ::sendmail::makeall

  validate_bool($enable_ipv4_daemon)
  validate_bool($enable_ipv6_daemon)

  # Order of fragments
  # -------------------------
  # 00    # file header
  # 01    VERSIONID
  # 05    OSTYPE
  # 07    DOMAIN
  # 10    # define header
  # 12    define
  # 20    # FEATURE header
  # 22    FEATURE
  # 30    # macro header
  # 38    MODIFY_MAILER_FLAGS
  # 40    DAEMON_OPTIONS
  # 45    TRUST_AUTH_MECH
  #       STARTTLS
  #       DNSBL
  #       Milter
  # 60    # MAILER header
  # 61-69 MAILER
  # 80    LOCAL_CONFIG header
  # 81    LOCAL_CONFIG
  #       LOCAL_RULE_*
  #       LOCAL_RULESETS

  concat { 'sendmail.mc':
    ensure => present,
    path   => '/tmp/sendmail.mc',
    owner  => 'root',
    group  => $::sendmail::params::sendmail_group,
    mode   => '0644',
  }

  concat::fragment { 'sendmail_mc-header':
    target  => 'sendmail.mc',
    order   => '00',
    content => template('sendmail/header.m4.erb'),
    notify  => Class['::sendmail::makeall'],
  }

  if ($ostype != undef) {
    ::sendmail::mc::ostype { $ostype: }
  }

  if ($sendmail_mc_domain != undef) {
    ::sendmail::mc::domain { $sendmail_mc_domain: }
  }

  if ($smart_host != undef) {
    ::sendmail::mc::define { 'SMART_HOST':
      expansion => $smart_host,
    }
  }

  if ($log_level != undef) {
    validate_re($log_level, '^\d+$', 'log_level must be numeric')
    ::sendmail::mc::define { 'confLOG_LEVEL':
      expansion => $log_level,
    }
  }

  if ($max_message_size != undef) {
    validate_re($max_message_size, '^\d+$', 'max_message_size must be numeric')
    ::sendmail::mc::define{ 'confMAX_MESSAGE_SIZE':
      expansion => $max_message_size,
    }
  }

  if ($dont_probe_interfaces != undef) {
    ::sendmail::mc::define { 'confDONT_PROBE_INTERFACES':
      expansion => $dont_probe_interfaces,
    }
  }
  if ($enable_ipv4_daemon) {
    ::sendmail::mc::daemon_options { 'MTA-v4':
      family => 'inet',
    }
  }

  if ($enable_ipv6_daemon) {
    ::sendmail::mc::daemon_options { 'MTA-v6':
      family => 'inet6',
      modify => 'O',
    }
  }

  ::sendmail::mc::mailer { 'local': }
  ::sendmail::mc::mailer { 'smtp': }
}
