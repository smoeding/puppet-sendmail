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
    smart_host            => undef,
    log_level             => $log_level,
    dont_probe_interfaces => true,
    enable_ipv4_daemon    => false,
    enable_ipv6_daemon    => false,
    mailers               => undef,
  }

  ::sendmail::mc::feature { 'nullclient':
    args => any2array($mail_hub),
  }
}
