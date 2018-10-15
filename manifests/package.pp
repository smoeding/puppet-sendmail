# = Class: sendmail::package
#
# Manage the Sendmail MTA package.
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
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'sendmail::package': }
#
#
class sendmail::package (
  Array[String] $auxiliary_packages = $::sendmail::params::auxiliary_packages,
  String        $package_ensure     = 'present',
  Boolean       $package_manage     = $::sendmail::params::package_manage,
) inherits ::sendmail::params {

  if $package_manage {
    package { $::sendmail::params::package_name:
      ensure => $package_ensure,
    }

    unless empty($auxiliary_packages) {
      ensure_packages($auxiliary_packages)
    }
  }
}
