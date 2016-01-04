# = Class: sendmail::nullclient
#
# Create a simple Sendmail nullclient configuration. No mail can be received
# from the outside. All local mail is forwarded to a given mail hub.
#
# == Parameters:
#
# [*mail_hub*]
#   The hostname or IP address of the mail hub where all mail is forwarded
#   to. It can be enclosed in brackets to prevent MX lookups.
#
# [*log_level*]
#   The loglevel for the sendmail process.
#   Valid options: a numeric value. Default value: undef.
#
# [*port*]
#   The port used for the local message submission agent. Default value:
#   '587'.
#
# [*port_option_modify*]
#   Port option modifiers for the local message submission agent. This
#   parameter is used to set the 'daemon_port_options'. Default value: undef
#
# [*ca_cert_file*]
#   The filename of the SSL CA certificate.
#
# [*ca_cert_path*]
#   The directory where SSL CA certificates are kept.
#
# [*server_cert_file*]
#   The filename of the SSL server certificate for inbound connections.
#
# [*server_key_file*]
#   The filename of the SSL server key for inbound connections.
#
# [*client_cert_file*]
#   The filename of the SSL client certificate for outbound connections.
#
# [*client_key_file*]
#   The filename of the SSL client key for outbound connections.
#
# [*crl_file*]
#   The filename with a list of revoked certificates.
#
# [*dh_params*]
#   The DH parameters used for encryption. This can be one of the numbers
#   '512', '1024', '2048' or a filename with generated parameters.
#
# [*cipher_list*]
#   Set the available ciphers for encrypted connections.
#
# [*server_ssl_options*]
#   Configure the SSL connection flags for inbound connections.
#
# [*client_ssl_options*]
#   Configure the SSL connection flags for outbound connections.
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
  $port               = '587',
  $port_option_modify = undef,
  $log_level          = undef,
  $ca_cert_file       = undef,
  $ca_cert_path       = undef,
  $server_cert_file   = undef,
  $server_key_file    = undef,
  $client_cert_file   = undef,
  $client_key_file    = undef,
  $crl_file           = undef,
  $dh_params          = undef,
  $tls_srv_options    = undef,
  $cipher_list        = undef,
  $server_ssl_options = undef,
  $client_ssl_options = undef,
) {

  validate_re($port, '^[0-9]+$')
  validate_re($port_option_modify, '^[abcfhruACEOS]*$')

  class { '::sendmail':
    log_level             => $log_level,
    dont_probe_interfaces => true,
    enable_ipv4_daemon    => false,
    enable_ipv6_daemon    => false,
    mailers               => [],
    ca_cert_file          => $ca_cert_file,
    ca_cert_path          => $ca_cert_path,
    server_cert_file      => $server_cert_file,
    server_key_file       => $server_key_file,
    client_cert_file      => $client_cert_file,
    client_key_file       => $client_key_file,
    crl_file              => $crl_file,
    dh_params             => $dh_params,
    tls_srv_options       => $tls_srv_options,
    cipher_list           => $cipher_list,
    server_ssl_options    => $server_ssl_options,
    client_ssl_options    => $client_ssl_options,
  }

  ::sendmail::mc::feature { 'no_default_msa': }

  ::sendmail::mc::daemon_options { 'MSA':
    family => 'inet',
    addr   => '127.0.0.1',
    port   => $port,
    modify => $port_option_modify,
  }

  ::sendmail::mc::feature { 'nullclient':
    args => [ $mail_hub ],
  }
}
