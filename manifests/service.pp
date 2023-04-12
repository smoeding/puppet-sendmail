# @summary Manage the Sendmail service.
#
# @api private
#
# @param service_name The service name to use on this operating system.  The
#   default is operating system specific.
#
# @param service_enable Configure whether the Sendmail MTA should be enabled
#   at boot.  Valid options: `true` or `false`.
#
# @param service_manage Configure whether Puppet should manage the Sendmail
#   service.  Valid options: `true` or `false`.
#
# @param service_ensure Configure whether the Sendmail service should be
#   running.  Valid options: `running` or `stopped`.
#
# @param service_hasstatus Define whether the service type can rely on
#   a functional status.  Valid options: `true` or `false`.
#
#
class sendmail::service (
  String                  $service_name      = $sendmail::params::service_name,
  Boolean                 $service_enable    = true,
  Boolean                 $service_manage    = true,
  Stdlib::Ensure::Service $service_ensure    = 'running',
  Boolean                 $service_hasstatus = true,
) inherits sendmail::params {

  if $service_manage {
    service { 'sendmail':
      ensure    => $service_ensure,
      name      => $service_name,
      enable    => $service_enable,
      hasstatus => $service_hasstatus,
    }
  }
}
