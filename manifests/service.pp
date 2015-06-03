# = Class: sendmail::service
#
# Manage the Sendmail MTS service.
#
# == Parameters:
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
#   class { 'sendmail::service':
#   }
#
#
class sendmail::service (
  $service_name      = $::sendmail::params::service_name,
  $service_enable    = true,
  $service_manage    = true,
  $service_ensure    = 'running',
  $service_hasstatus = $::sendmail::params::service_hasstatus,
) inherits ::sendmail::params {

  validate_bool($service_enable)
  validate_bool($service_manage)

  case $service_ensure {
    true, 'running': {
      $_service_ensure = 'running'
    }
    false, 'stopped': {
      $_service_ensure = 'stopped'
    }
    default: {
      $_service_ensure = undef
    }
  }

  if $service_manage {
    service { 'sendmail':
      ensure    => $_service_ensure,
      name      => $service_name,
      enable    => $service_enable,
      hasstatus => $service_hasstatus,
    }
  }
}
