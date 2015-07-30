# = Class: sendmail
#
# Manage the sendmail MTA.
#
# == Parameters:
#
# [*cf_version*]
#   The configuration version string for Sendmail. This string will be
#   appended to the Sendmail version in the HELO message. If unset, no
#   configuration version will be used.
#   Default value: undef.
#
# [*smart_host*]
#   Servers that are behind a firewall may not be able to deliver mail
#   directly to the outside world. In this case the host may need to forward
#   the mail to the gateway machine defined by this parameter. All nonlocal
#   mail is forwarded to this gateway.
#   Default value: undef.
#
# [*log_level*]
#   The loglevel for the sendmail process.
#   Valid options: a numeric value. Default value: undef.
#
# [*dont_probe_interfaces*]
#   Sendmail normally probes all network interfaces to get the hostnames that
#   the server may have. These hostnames are then considered local. This
#   option can be used to prevent the reverse lookup of the network addresses.
#   If this option is set to 'localhost' then all network interfaces except
#   for the loopback interface is probed.
#   Valid options: the strings 'true', 'false' or 'localhost'.
#   Default value: undef.
#
# [*enable_ipv4_daemon*]
#   Should the host accept mail on all IPv4 network adresses.
#   Valid options: 'true' or 'false'. Default value: 'true'.
#
# [*enable_ipv6_daemon*]
#   Should the host accept mail on all IPv6 network adresses.
#   Valid options: 'true' or 'false'. Default value: 'true'.
#
# [*enable_aliases*]
#   Automaticall manage the aliases file. This parameter only manages the
#   file and not the content.
#   Valid options: 'true' or 'false'. Default value: 'true'.
#
# [*enable_access_db*]
#   Automatically manage the access database file. This parameter only
#   manages the file and not the content.
#   Valid options: 'true' or 'false'. Default value: 'true'.
#
# [*mailers*]
#   An array of mailers to add to the configuration.
#   Default value: [ 'smtp', 'local' ]
#
# [*local_host_names*]
#   An array of hostnames that Sendmail considers for a local delivery.
#   Default values: [ $::fqdn ]
#
# [*relay_domains*]
#   An array of domains that Sendmail accepts as relay target. This
#   setting is required for secondary MX setups.
#   Default value: []
#
# [*trusted_users*]
#   An array of user names that will be written into the trusted users file.
#   Leading or trailing whitespace is ignored. Empty entries are also
#   ignored. Default value: []
#
# [*trust_auth_mech*]
#   The value of the TRUST_AUTH_MECH macro to set. If this is a string it
#   is used as-is. For an array the value will be concatenated into a
#   string. Default value: undef
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
#   Set the available ciphers for encrypted conections.
#
# [*server_ssl_options*]
#   Configure the SSL connection flags for inbound connections.
#
# [*client_ssl_options*]
#   Configure the SSL connection flags for outbound connections.
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
# [*service_name*]
#   The service name to use on this operating system.
#
# [*service_enable*]
#   Configure whether the Sendmail MTA should be enabled at boot.
#   Valid options: 'true' or 'false'. Default value: 'true'.
#
# [*service_manage*]
#   Configure whether Puppet should manage the Sendmail service.
#   Valid options: 'true' or 'false'. Default value: 'true'.
#
# [*service_ensure*]
#   Configure whether the Sendmail service should be running.
#   Valid options: 'running' or 'stopped'. Default value: 'running'.
#
# [*service_hasstatus*]
#   Define whether the service type can rely on a functional status.
#   Valid options: 'true' or 'false'. Default value depends on
#   the operating system and release.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#  class { 'sendmail:
#  }
#
#
class sendmail (
  $cf_version            = undef,
  $smart_host            = undef,
  $log_level             = undef,
  $dont_probe_interfaces = undef,
  $enable_ipv4_daemon    = true,
  $enable_ipv6_daemon    = true,
  $enable_aliases        = true,
  $enable_access_db      = true,
  $mailers               = $::sendmail::params::mailers,
  $local_host_names      = [ $::fqdn ],
  $relay_domains         = [],
  $trusted_users         = [],
  $trust_auth_mech       = undef,
  $ca_cert_file          = undef,
  $ca_cert_path          = undef,
  $server_cert_file      = undef,
  $server_key_file       = undef,
  $client_cert_file      = undef,
  $client_key_file       = undef,
  $crl_file              = undef,
  $dh_params             = undef,
  $tls_srv_options       = undef,
  $cipher_list           = undef,
  $server_ssl_options    = undef,
  $client_ssl_options    = undef,
  $manage_sendmail_mc    = true,
  $manage_submit_mc      = true,
  $auxiliary_packages    = $::sendmail::params::auxiliary_packages,
  $package_ensure        = 'present',
  $package_manage        = true,
  $service_name          = $::sendmail::params::service_name,
  $service_enable        = true,
  $service_manage        = true,
  $service_ensure        = 'running',
  $service_hasstatus     = $::sendmail::params::service_hasstatus,
) inherits ::sendmail::params {

  validate_bool($enable_access_db)
  validate_bool($manage_sendmail_mc)
  validate_bool($manage_submit_mc)

  anchor { 'sendmail::begin': }

  class { '::sendmail::package':
    auxiliary_packages => $auxiliary_packages,
    package_ensure     => $package_ensure,
    package_manage     => $package_manage,
    before             => Anchor['sendmail::config'],
    require            => Anchor['sendmail::begin'],
  }

  class { '::sendmail::local_host_names':
    local_host_names => $local_host_names,
    require          => Class['sendmail::package'],
  }

  class { '::sendmail::relay_domains':
    relay_domains => $relay_domains,
    require       => Class['sendmail::package'],
  }

  class { '::sendmail::trusted_users':
    trusted_users => $trusted_users,
    require       => Class['sendmail::package'],
  }

  if ($enable_aliases) {
    include ::sendmail::aliases
  }

  if ($enable_access_db) {
    include ::sendmail::access
  }

  if ($manage_sendmail_mc) {
    class { '::sendmail::mc':
      cf_version            => $cf_version,
      smart_host            => $smart_host,
      log_level             => $log_level,
      dont_probe_interfaces => $dont_probe_interfaces,
      enable_ipv4_daemon    => $enable_ipv4_daemon,
      enable_ipv6_daemon    => $enable_ipv6_daemon,
      mailers               => $mailers,
      trust_auth_mech       => $trust_auth_mech,
      before                => Anchor['sendmail::config'],
      require               => Class['::sendmail::package'],
      notify                => Class['::sendmail::service'],
    }

    # Include STARTTLS settings if any of the options is defined
    $tls_opts = [
      $ca_cert_file, $ca_cert_path, $server_cert_file, $server_key_file,
      $client_cert_file, $client_key_file, $crl_file, $tls_srv_options,
      $cipher_list, $server_ssl_options, $client_ssl_options, $dh_params,
    ]

    if (count($tls_opts) > 0) {
      sendmail::mc::starttls { 'starttls':
        ca_cert_file       => $ca_cert_file,
        ca_cert_path       => $ca_cert_path,
        server_cert_file   => $server_cert_file,
        server_key_file    => $server_key_file,
        client_cert_file   => $client_cert_file,
        client_key_file    => $client_key_file,
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
    class { '::sendmail::submit':
      before  => Anchor['sendmail::config'],
      require => Class['::sendmail::package'],
      notify  => Class['::sendmail::service'],
    }
  }

  anchor { 'sendmail::config': }

  class { '::sendmail::service':
    service_name      => $service_name,
    service_enable    => $service_enable,
    service_manage    => $service_manage,
    service_ensure    => $service_ensure,
    service_hasstatus => $service_hasstatus,
    require           => Anchor['sendmail::config'],
    before            => Anchor['sendmail::end'],
  }

  anchor { 'sendmail::end': }
}
