# = Class: sendmail::files::aliases
#
# Create the Sendmail aliases file.
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
#   class { 'sendmail::files::aliases': }
#
#
class sendmail::files::aliases {
  include ::sendmail::params

  file { '/etc/aliases':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }
}
