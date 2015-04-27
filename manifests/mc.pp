# = Class: sendmail::mc
#
# Manage the sendmail.mc file
#
# == Parameters:
#
# None.
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
  $sendmail_domain    = 'generic',
  $smart_host         = undef,
  $enable_ipv4_daemon = true,
  $enable_ipv6_daemon = true,
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

  ::sendmail::mc::domain { $sendmail_domain: }

  if ($smart_host != undef) {
    ::sendmail::mc::define { 'SMART_HOST':
      expansion => $smart_host,
    }
  }

  if ($enable_ipv4_daemon) {
    ::sendmail::mc::daemon_options { 'IPv4':
      family => 'inet',
    }
  }

  if ($enable_ipv6_daemon) {
    ::sendmail::mc::daemon_options { 'IPv6':
      family => 'inet6',
      modify => 'O',
    }
  }

  ::sendmail::mc::mailer { 'local': }
  ::sendmail::mc::mailer { 'smtp': }
}
