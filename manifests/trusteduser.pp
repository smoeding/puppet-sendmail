# = Define: sendmail::trusteduser
#
# Create or remove a user entry in the trusted-users file.
#
# == Parameters:
#
# [*user*]
#   The username to add or remove.
#
# [*ensure*]
#   Use *present* to create the entry or *absent* to remove it.
#   Default: present
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::trusteduser { 'fred':
#     ensure => present,
#   }
#
#   sendmail::trusteduser { 'barney':
#     ensure => absent,
#   }
#
#
define sendmail::trusteduser (
  $user   = $name,
  $ensure = present
) {
  include ::sendmail::params
  include ::sendmail::trusteduser::create

  # The Augeas command 'rm' removes a node and the command 'clear' sets a node
  # to NULL (creating it if needed).
  $command = $ensure ? {
    absent  => 'rm',
    default => 'clear',
  }

  augeas { "/etc/mail/trusted-users-${user}":
    lens    => 'Sendmail_List.lns',
    incl    => '/etc/mail/trusted-users',
    changes => "${command} ${user}",
    require => Class['::sendmail::trusteduser::create'],
  }
}
