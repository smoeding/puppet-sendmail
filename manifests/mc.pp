# = Class: sendmail::mc
#
# Manage the sendmail.mc file
#
# == Parameters:
#
# [*sendmail_domain*]
#
# [*smart_host*]
#
# [*log_level*]
#
# [*dont_probe_interfaces*]
#
# [*enable_ipv4_daemon*]
#
# [*enable_ipv6_daemon*]
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
  $sendmail_domain       = 'generic',
  $smart_host            = undef,
  $log_level             = undef,
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
  # 30    # FEATURE header
  # 32    FEATURE
  # 40    # macro header
  # 58    MODIFY_MAILER_FLAGS
  # 60    DAEMON_OPTIONS
  # 75    TRUST_AUTH_MECH
  # 80    # MAILER header
  # 81-89 MAILER

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

  if ($sendmail_domain != undef) {
    ::sendmail::mc::domain { $sendmail_domain: }
  }

  if ($smart_host != undef) {
    ::sendmail::mc::define { 'SMART_HOST':
      expansion => $smart_host,
    }
  }

  if ($log_level != undef) {
    ::sendmail::mc::define { 'confLOG_LEVEL':
      expansion => $log_level,
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
