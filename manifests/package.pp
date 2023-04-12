# @summary Manage the Sendmail MTA package.
#
# @api private
#
# @param auxiliary_packages Additional packages that will be installed by the
#   Sendmail module.  Valid options: array of strings.  The default varies by
#   operating system.
#
# @param package_ensure Configure whether the Sendmail package should be
#   installed, and what version.  Valid options: `present`, `latest`, or
#   a specific version number.
#
# @param package_manage Configure whether Puppet should manage the Sendmail
#   package(s).  Valid options: `true` or `false`.  The default is `true`.
#
#
class sendmail::package (
  Array[String] $auxiliary_packages = $sendmail::params::auxiliary_packages,
  String        $package_ensure     = 'present',
  Boolean       $package_manage     = $sendmail::params::package_manage,
) inherits sendmail::params {
  if $package_manage {
    package { $sendmail::params::package_name:
      ensure => $package_ensure,
    }

    unless empty($auxiliary_packages) {
      ensure_packages($auxiliary_packages)
    }
  }
}
