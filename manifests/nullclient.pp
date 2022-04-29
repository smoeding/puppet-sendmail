# @summary Create a simple Sendmail nullclient configuration.
#
# No mail can be received from the outside since the Sendmail daemon only
# listens on the localhost address `127.0.0.1`. All local mail is forwarded
# to a given mail hub.
#
# This is a convenience class to make the configuration simple. Internally it
# declares the `sendmail` class using appropriate parameters. Normally no
# other configuration should be necessary.
#
# @example Create a nullclient config forwarding to a given hub
#   class { 'sendmail::nullclient':
#     mail_hub => '[192.168.1.1]',
#   }
#
# @param mail_hub The hostname or IP address of the mail hub where all mail
#   is forwarded to.  It can be enclosed in brackets to prevent MX lookups.
#
# @param port The port used for the local message submission agent.
#
# @param port_option_modify Port option modifiers for the local message
#   submission agent.  The parameter is used to set the
#   `daemon_port_options`.  A useful value for the nullclient configuration
#   might be `S` to prevent offering STARTTLS on the MSA port.
#
# @param enable_ipv4_msa Enable the local message submission agent on the
#   IPv4 loopback address (`127.0.0.1`).  Valid options: `true` or `false`.
#
# @param enable_ipv6_msa Enable the local message submission agent on the
#   IPv6 loopback address (`::1`).  Valid options: `true` or `false`.
#
# @param enable_msp_trusted_users Whether the trusted users file feature is
#   enabled for the message submission program.  This may be necessary if you
#   want to allow certain users to change the sender address using `sendmail
#   -f`.  Valid options: `true` or `false`.
#
# @param trusted_users An array of user names that will be written into the
#   trusted users file.  Leading or trailing whitespace is ignored.  Empty
#   entries are also ignored.
#
# @param domain_name Sets the official canonical name of the local machine.
#   Normally this parameter is not required as Sendmail uses the fully
#   qualified domain name by default.  Setting this parameter will override
#   the value of the `$j` macro in the sendmail.cf file.
#
# @param max_message_size Define the maximum message size that will be
#   accepted.  This can be a pure numerical value given in bytes
#   (e.g. 33554432) or a number with a prefixed byte unit (e.g. 32MB).  The
#   conversion is done using the 1024 convention (see the `to_bytes` function
#   in the `stdlib` module), so valid prefixes are either `k` for 1024 bytes
#   or `M` for 1048576 bytes.
#
# @param log_level The loglevel for the sendmail process.  Valid options:
#   a numeric value.
#
# @param ca_cert_file The filename of the SSL CA certificate.
#
# @param ca_cert_path The directory where SSL CA certificates are kept.
#
# @param server_cert_file The filename of the SSL server certificate for
#   inbound connections.
#
# @param server_key_file The filename of the SSL server key for inbound
#   connections.
#
# @param client_cert_file The filename of the SSL client certificate for
#   outbound connections.
#
# @param client_key_file The filename of the SSL client key for outbound
#   connections.
#
# @param crl_file The filename with a list of revoked certificates.
#
# @param dh_params The DH parameters used for encryption.  This can be one of
#   the numbers `512`, `1024`, `2048` or a filename with generated
#   parameters.
#
# @param tls_srv_options The parameter adjusts the server TLS settings.  This
#   can currently be either the letter `V` or the empty string.  Setting this
#   parameter to `V` disables the request for a client certificate.
#
# @param cipher_list Set the available ciphers for encrypted connections.
#
# @param server_ssl_options Configure the SSL connection flags for inbound
#   connections.
#
# @param client_ssl_options Configure the SSL connection flags for outbound
#  connections.
#
#
class sendmail::nullclient (
  String                                 $mail_hub,
  Pattern[/^[0-9]+$/]                    $port                     = '587',
  Optional[Pattern[/^[abcfhruACEOS]*$/]] $port_option_modify       = undef,
  Boolean                                $enable_ipv4_msa          = true,
  Boolean                                $enable_ipv6_msa          = true,
  Boolean                                $enable_msp_trusted_users = false,
  Array[String]                          $trusted_users            = [],
  Optional[String]                       $domain_name              = undef,
  Optional[Sendmail::Messagesize]        $max_message_size         = undef,
  Optional[Sendmail::Loglevel]           $log_level                = undef,
  Optional[Stdlib::Absolutepath]         $ca_cert_file             = undef,
  Optional[Stdlib::Absolutepath]         $ca_cert_path             = undef,
  Optional[Stdlib::Absolutepath]         $server_cert_file         = undef,
  Optional[Stdlib::Absolutepath]         $server_key_file          = undef,
  Optional[Stdlib::Absolutepath]         $client_cert_file         = undef,
  Optional[Stdlib::Absolutepath]         $client_key_file          = undef,
  Optional[Stdlib::Absolutepath]         $crl_file                 = undef,
  Optional[Sendmail::DHParam]            $dh_params                = undef,
  Optional[Enum['V']]                    $tls_srv_options          = undef,
  Optional[String]                       $cipher_list              = undef,
  Optional[String]                       $server_ssl_options       = undef,
  Optional[String]                       $client_ssl_options       = undef,
) {

  unless ($enable_ipv4_msa or $enable_ipv6_msa) {
    fail('The MSA must be enabled for IPv4 or IPv6 or both')
  }

  class { 'sendmail':
    domain_name              => $domain_name,
    max_message_size         => $max_message_size,
    log_level                => $log_level,
    dont_probe_interfaces    => true,
    enable_ipv4_daemon       => false,
    enable_ipv6_daemon       => false,
    mailers                  => [],
    enable_msp_trusted_users => $enable_msp_trusted_users,
    trusted_users            => $trusted_users,
    ca_cert_file             => $ca_cert_file,
    ca_cert_path             => $ca_cert_path,
    server_cert_file         => $server_cert_file,
    server_key_file          => $server_key_file,
    client_cert_file         => $client_cert_file,
    client_key_file          => $client_key_file,
    crl_file                 => $crl_file,
    dh_params                => $dh_params,
    tls_srv_options          => $tls_srv_options,
    cipher_list              => $cipher_list,
    server_ssl_options       => $server_ssl_options,
    client_ssl_options       => $client_ssl_options,
  }

  sendmail::mc::feature { 'no_default_msa': }

  if ($enable_ipv4_msa) {
    sendmail::mc::daemon_options { 'MSA-v4':
      daemon_name => 'MSA',
      family      => 'inet',
      addr        => '127.0.0.1',
      port        => $port,
      modify      => $port_option_modify,
    }
  }

  if ($enable_ipv6_msa) {
    sendmail::mc::daemon_options { 'MSA-v6':
      daemon_name => 'MSA',
      family      => 'inet6',
      addr        => '::1',
      port        => $port,
      modify      => $port_option_modify,
    }
  }

  sendmail::mc::feature { 'nullclient':
    args => [ $mail_hub ],
  }
}
