# = Class: sendmail::nullclient
#
# Manage sendmail::nullclient
#
# == Parameters:
#
# [*mail_hub*]
#   The name of the mail hub where all mail is forwarded to.
#   The name or ip address can be enclosed in brackets to prevent MX lookups.
#
# [*log_level*]
#   The loglevel for the sendmail process.
#   Valid options: a numeric value. Default value: undef.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'sendmail::nullclient':
#     mail_hub => '[192.168.1.1]',
#   }
#
#
class sendmail::nullclient (
  $mail_hub,
  $log_level = undef,
) {

  class { '::sendmail':
    log_level             => $log_level,
    dont_probe_interfaces => true,
    enable_ipv4_daemon    => false,
    enable_ipv6_daemon    => false,
    mailers               => [],
  }

  ::sendmail::mc::feature { 'no_default_msa': }

  ::sendmail::mc::daemon_options { 'MTA':
    family => 'inet',
    addr   => '127.0.0.1',
    port   => '587',
  }

  ::sendmail::mc::feature { 'nullclient':
    args => [ $mail_hub ],
  }
}
