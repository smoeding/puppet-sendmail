# = Class: sendmail::alias::create
#
# Create the Sendmail alias file.
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
#   class { 'sendmail::alias::create': }
#
#
class sendmail::alias::create {
  include ::sendmail::params

  file { '/etc/aliases':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }
}
