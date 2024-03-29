# @summary Manage the Sendmail MTA.
#
# Perform the basic setup and installation of Sendmail on the system.
#
# @example
#   class { 'sendmail': }
#
# @param smart_host Servers that are behind a firewall may not be able to
#   deliver mail directly to the outside world.  In this case the host may
#   need to forward the mail to the gateway machine defined by this
#   parameter.  All nonlocal mail is forwarded to this gateway.
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
# @param dont_probe_interfaces Sendmail normally probes all network
#   interfaces to get the hostnames that the server may have.  These
#   hostnames are then considered local.  This option can be used to prevent
#   the reverse lookup of the network addresses.  If this option is set to
#   `localhost` then all network interfaces except for the loopback interface
#   is probed.  Valid options: the strings `true`, `false` or `localhost`.
#
# @param features A hash of features to include in the configuration.  Each
#   hash key should be a feature name while the value should be a hash
#   itself.  The value hash is used as parameters for the
#   `sendmail::mc::feature` defined type.  Check the documentation of this
#   type for details.
#
#   Some features (e.g. `mailertable`, `access_db`, ...) may need to be
#   managed individually. So the `mailertable` feature could be enabled using
#   this parameter but that does not manage the mailertable file itself. So
#   in addition you would have to use the `sendmail::mailertable` class or
#   the `sendmail::mailertable::entry` defined type.
#
# @param enable_ipv4_daemon Should the host accept mail on all IPv4 network
#   adresses.  Valid options: `true` or `false`.
#
# @param enable_ipv6_daemon Should the host accept mail on all IPv6 network
#   adresses.  Valid options: `true` or `false`.
#
# @param mailers An array of mailers to add to the configuration.  The
#   default is `[ 'smtp', 'local' ]`.
#
# @param local_host_names An array of hostnames that Sendmail considers for
#   a local delivery.
#
# @param relay_domains An array of domains that Sendmail accepts as relay
#   target.  This setting is required for secondary MX setups.
#
# @param trusted_users An array of user names that will be written into the
#   trusted users file.  Leading or trailing whitespace is ignored.  Empty
#   entries are also ignored.
#
# @param trust_auth_mech The value of the `TRUST_AUTH_MECH` macro to set.  If
#   this is a string it is used as-is.  For an array the value will be
#   concatenated into a string.
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
# @param server_cert_file2 The filename of the secondary SSL server
#   certificate for inbound connections.  The parameter is only valid on
#   Sendmail 8.15.1 or later and when `server_cert_file` is set.
#
# @param server_key_file2 The filename of the secondary SSL server key for
#   inbound connections.  The parameter is only valid on Sendmail 8.15.1 or
#   later and when `server_key_file` is set.
#
# @param client_cert_file2 The filename of the secondary SSL client
#   certificate for outbound connections.  The parameter is only valid on
#   Sendmail 8.15.1 or later and when `client_cert_file` is set.
#
# @param client_key_file2 The filename of the secondary SSL client key for
#   outbound connections.  The parameter is only valid on Sendmail 8.15.1 or
#   later and when `client_key_file` is set.
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
#   connections.
#
# @param cf_version The configuration version string for Sendmail.  This
#   string will be appended to the Sendmail version in the `HELO` message.
#   If unset, no configuration version will be used.
#
# @param version_id The version id string included in the sendmail.mc file.
#   This has no practical meaning other than having a used defined identifier
#   in the file.
#
# @param msp_host The host where the message submission program should
#   deliver to.  This can be a hostname or IP address.  To prevent MX lookups
#   for the host, put it in square brackets (e.g., `[hostname]`).  Delivery
#   to the local host would therefore use either `[127.0.0.1]` for IPv4 or
#   `[IPv6:::1]` for IPv6.
#
# @param msp_port The port used for the message submission program.  Can be
#   a port number (e.g., `25`) or the literal `MSA` for delivery to the
#   message submission agent on port 587.
#
# @param enable_msp_trusted_users Whether the trusted users file feature is
#   enabled for the message submission program.  This may be necessary if you
#   want to allow certain users to change the sender address using `sendmail
#   -f`.  Valid options: `true` or `false`.
#
# @param manage_sendmail_mc Whether to automatically manage the `sendmail.mc`
#   file.  Valid options: `true` or `false`.
#
# @param manage_submit_mc Whether to automatically manage the `submit.mc`
#   file.  Valid options: `true` or `false`.
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
#   package(s).  Valid options: `true` or `false`.
#
# @param service_name The service name to use on this operating system.
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
class sendmail (
  Optional[String]                        $smart_host               = undef,
  Optional[String]                        $domain_name              = undef,
  Optional[String]                        $max_message_size         = undef,
  Optional[Sendmail::Loglevel]            $log_level                = undef,
  Optional[Boolean]                       $dont_probe_interfaces    = undef,
  Boolean                                 $enable_ipv4_daemon       = true,
  Boolean                                 $enable_ipv6_daemon       = true,
  Hash[String,Data]                       $features                 = {},
  Array[String]                           $mailers                  = $sendmail::params::mailers,
  Array[String]                           $local_host_names         = [$facts['networking']['fqdn']],
  Array[String]                           $relay_domains            = [],
  Array[String]                           $trusted_users            = [],
  Optional[Variant[String,Array[String]]] $trust_auth_mech          = undef,
  Optional[Stdlib::Absolutepath]          $ca_cert_file             = undef,
  Optional[Stdlib::Absolutepath]          $ca_cert_path             = undef,
  Optional[Stdlib::Absolutepath]          $server_cert_file         = undef,
  Optional[Stdlib::Absolutepath]          $server_key_file          = undef,
  Optional[Stdlib::Absolutepath]          $client_cert_file         = undef,
  Optional[Stdlib::Absolutepath]          $client_key_file          = undef,
  Optional[Stdlib::Absolutepath]          $server_cert_file2        = undef,
  Optional[Stdlib::Absolutepath]          $server_key_file2         = undef,
  Optional[Stdlib::Absolutepath]          $client_cert_file2        = undef,
  Optional[Stdlib::Absolutepath]          $client_key_file2         = undef,
  Optional[Stdlib::Absolutepath]          $crl_file                 = undef,
  Optional[Sendmail::DHParam]             $dh_params                = undef,
  Optional[Enum['V','']]                  $tls_srv_options          = undef,
  Optional[String]                        $cipher_list              = undef,
  Optional[String]                        $server_ssl_options       = undef,
  Optional[String]                        $client_ssl_options       = undef,
  Optional[String]                        $cf_version               = undef,
  Optional[String]                        $version_id               = undef,
  String                                  $msp_host                 = '[127.0.0.1]',
  Pattern[/^(MSA)|([0-9]+)$/]             $msp_port                 = 'MSA',
  Boolean                                 $enable_msp_trusted_users = false,
  Boolean                                 $manage_sendmail_mc       = true,
  Boolean                                 $manage_submit_mc         = true,
  Array[String]                           $auxiliary_packages       = $sendmail::params::auxiliary_packages,
  String                                  $package_ensure           = 'present',
  Boolean                                 $package_manage           = $sendmail::params::package_manage,
  String                                  $service_name             = $sendmail::params::service_name,
  Boolean                                 $service_enable           = true,
  Boolean                                 $service_manage           = true,
  Stdlib::Ensure::Service                 $service_ensure           = 'running',
  Boolean                                 $service_hasstatus        = true,
) inherits sendmail::params {
  class { 'sendmail::package':
    auxiliary_packages => $auxiliary_packages,
    package_ensure     => $package_ensure,
    package_manage     => $package_manage,
  }

  class { 'sendmail::local_host_names':
    local_host_names => $local_host_names,
    require          => Class['sendmail::package'],
  }

  class { 'sendmail::relay_domains':
    relay_domains => $relay_domains,
    require       => Class['sendmail::package'],
  }

  class { 'sendmail::trusted_users':
    trusted_users => $trusted_users,
    require       => Class['sendmail::package'],
  }

  if ($manage_sendmail_mc) {
    class { 'sendmail::mc':
      cf_version            => $cf_version,
      domain_name           => $domain_name,
      smart_host            => $smart_host,
      max_message_size      => $max_message_size,
      log_level             => $log_level,
      dont_probe_interfaces => $dont_probe_interfaces,
      enable_ipv4_daemon    => $enable_ipv4_daemon,
      enable_ipv6_daemon    => $enable_ipv6_daemon,
      mailers               => $mailers,
      trust_auth_mech       => $trust_auth_mech,
      version_id            => $version_id,
      require               => Class['sendmail::package'],
      notify                => Class['sendmail::service'],
    }

    # Include STARTTLS settings if any of the options is defined
    $tls_opts = [
      $ca_cert_file, $ca_cert_path, $server_cert_file, $server_key_file,
      $client_cert_file, $client_key_file, $crl_file, $tls_srv_options,
      $cipher_list, $server_ssl_options, $client_ssl_options, $dh_params,
    ]

    if (count($tls_opts) > 0) {
      class { 'sendmail::mc::starttls':
        ca_cert_file       => $ca_cert_file,
        ca_cert_path       => $ca_cert_path,
        server_cert_file   => $server_cert_file,
        server_key_file    => $server_key_file,
        client_cert_file   => $client_cert_file,
        client_key_file    => $client_key_file,
        server_cert_file2  => $server_cert_file2,
        server_key_file2   => $server_key_file2,
        client_cert_file2  => $client_cert_file2,
        client_key_file2   => $client_key_file2,
        crl_file           => $crl_file,
        dh_params          => $dh_params,
        tls_srv_options    => $tls_srv_options,
        cipher_list        => $cipher_list,
        server_ssl_options => $server_ssl_options,
        client_ssl_options => $client_ssl_options,
      }
    }
  }

  if ($manage_submit_mc) {
    class { 'sendmail::submit':
      msp_host                 => $msp_host,
      msp_port                 => $msp_port,
      enable_msp_trusted_users => $enable_msp_trusted_users,
      require                  => Class['sendmail::package'],
      notify                   => Class['sendmail::service'],
    }
  }

  $features.each |$feature,$attributes| {
    sendmail::mc::feature { $feature:
      * => $attributes,
    }
  }

  class { 'sendmail::service':
    service_name      => $service_name,
    service_enable    => $service_enable,
    service_manage    => $service_manage,
    service_ensure    => $service_ensure,
    service_hasstatus => $service_hasstatus,
  }
}
