# = Class: sendmail
#
# Manage the sendmail MTA.
#
# == Parameters:
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
  $manage_sendmail_mc = true,
  $manage_submit_mc   = true,
  $auxiliary_packages = $::sendmail::params::auxiliary_packages,
  $package_ensure     = 'present',
  $package_manage     = true,
  $service_name       = $::sendmail::params::service_name,
  $service_enable     = true,
  $service_manage     = true,
  $service_ensure     = 'running',
) inherits ::sendmail::params {

  validate_bool($manage_sendmail_mc)
  validate_bool($manage_submit_mc)

  anchor { '::sendmail::begin': }

  class { '::sendmail::package':
    auxiliary_packages => $auxiliary_packages,
    package_ensure     => $package_ensure,
    package_manage     => $package_manage,
    require            => Anchor['::sendmail::begin'],
  }

  if ($manage_sendmail_mc) {
    include ::sendmail::mc
  }

  class { '::sendmail::service':
    service_name   => $service_name,
    service_enable => $service_enable,
    service_manage => $service_manage,
    service_ensure => $service_ensure,
    require        => Class['::sendmail::package'],
    before         => Anchor['::sendmail::end'],
  }

  anchor { '::sendmail::end': }
}
