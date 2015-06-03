# = Class: sendmail
#
# Manage the sendmail MTA.
#
# == Parameters:
#
# [*smart_host*]
#   Servers that are behind a firewall may not be able to deliver mail
#   directly to the outside world. In this case the host may need to forward
#   the mail to the gateway machine defined by this parameter. All nonlocal
#   mail is forwarded to this gateway.
#   Default value: undef.
#
# [*log_level*]
#   The loglevel for the sendmail process.
#   Valid options: a numeric value. Default value: undef.
#
# [*dont_probe_interfaces*]
#   Sendmail normally probes all network interfaces to get the hostnames that
#   the server may have. These hostnames are then considered local. This
#   option can be used to prevent the reverse lookup of the network addresses.
#   If this option is set to 'localhost' then all network interfaces except
#   for the loopback interface is probed.
#   Valid options: the strings 'true', 'false' or 'localhost'.
#   Default value: undef.
#
# [*enable_ipv4_daemon*]
#   Should the host accept mail on all IPv4 network adresses.
#   Valid options: 'true' or 'false'. Default value: 'true'.
#
# [*enable_ipv6_daemon*]
#   Should the host accept mail on all IPv6 network adresses.
#   Valid options: 'true' or 'false'. Default value: 'true'.
#
# [*auxiliary_packages*]
#   Additional packages that will be installed by the Sendmail module.
#   Valid options: array of strings.
#   Default value: varies by operating system.
#
# [*package_ensure*]
#   Configure whether the Sendmail package should be installed, and what
#   version.
#   Valid options: 'present', 'latest', or a specific version number.
#   Default value: 'present'
#
# [*package_manage*]
#   Configure whether Puppet should manage the Sendmail package(s).
#   Valid options: 'true' or 'false'. Default value: 'true'.
#
# [*service_name*]
#   The service name to use on this operating system.
#
# [*service_enable*]
#   Configure whether the Sendmail MTA should be enabled at boot.
#   Valid options: 'true' or 'false'. Default value: 'true'.
#
# [*service_manage*]
#   Configure whether Puppet should manage the Sendmail service.
#   Valid options: 'true' or 'false'. Default value: 'true'.
#
# [*service_ensure*]
#   Configure whether the Sendmail service should be running.
#   Valid options: 'running' or 'stopped'. Default value: 'running'.
#
# [*service_hasstatus*]
#   Define whether the service type can rely on a functional status.
#   Valid options: 'true' or 'false'. Default value depends on
#   the operating system and release.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#  class { 'sendmail:
#  }
#
#
class sendmail (
  $smart_host            = undef,
  $log_level             = undef,
  $dont_probe_interfaces = undef,
  $enable_ipv4_daemon    = true,
  $enable_ipv6_daemon    = true,
  $manage_sendmail_mc    = true,
  $manage_submit_mc      = true,
  $auxiliary_packages    = $::sendmail::params::auxiliary_packages,
  $package_ensure        = 'present',
  $package_manage        = true,
  $service_name          = $::sendmail::params::service_name,
  $service_enable        = true,
  $service_manage        = true,
  $service_ensure        = 'running',
  $service_hasstatus     = $::sendmail::params::service_hasstatus,
) inherits ::sendmail::params {

  validate_bool($manage_sendmail_mc)
  validate_bool($manage_submit_mc)

  anchor { 'sendmail::begin': }

  class { '::sendmail::package':
    auxiliary_packages => $auxiliary_packages,
    package_ensure     => $package_ensure,
    package_manage     => $package_manage,
    before             => Anchor['sendmail::config'],
    require            => Anchor['sendmail::begin'],
  }

  if ($manage_sendmail_mc) {
    class { '::sendmail::mc':
      smart_host            => $smart_host,
      log_level             => $log_level,
      dont_probe_interfaces => $dont_probe_interfaces,
      enable_ipv4_daemon    => $enable_ipv4_daemon,
      enable_ipv6_daemon    => $enable_ipv6_daemon,
      before                => Anchor['sendmail::config'],
      require               => Class['::sendmail::package'],
      notify                => Class['::sendmail::service'],
    }
  }

  if ($manage_submit_mc) {
    class { '::sendmail::submit':
      before  => Anchor['sendmail::config'],
      require => Class['::sendmail::package'],
      notify  => Class['::sendmail::service'],
    }
  }

  anchor { 'sendmail::config': }

  class { '::sendmail::service':
    service_name      => $service_name,
    service_enable    => $service_enable,
    service_manage    => $service_manage,
    service_ensure    => $service_ensure,
    service_hasstatus => $service_hasstatus,
    require           => Anchor['sendmail::config'],
    before            => Anchor['sendmail::end'],
  }

  anchor { 'sendmail::end': }
}
