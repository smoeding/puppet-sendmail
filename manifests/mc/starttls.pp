# = Class sendmail::mc::starttls
#
# Manage STARTTLS parameters in the 'sendmail.mc' file.
#
# == Parameters:
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
#   class { sendmail::mc::starttls':
#     ca_cert_file     => '/etc/mail/tls/my-ca-cert.pem',
#     server_cert_file => '/etc/mail/tls/server.pem',
#     server_key_file  => '/etc/mail/tls/server.key',
#     client_cert_file => '/etc/mail/tls/server.pem',
#     client_key_file  => '/etc/mail/tls/server.key',
#     cipher_list      => 'HIGH:!MD5:!eNULL'
#   }
#
#
class sendmail::mc::starttls (
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
  include ::sendmail::makeall

  if $ca_cert_file     { validate_absolute_path($ca_cert_file) }
  if $ca_cert_path     { validate_absolute_path($ca_cert_path) }
  if $server_cert_file { validate_absolute_path($server_cert_file) }
  if $server_key_file  { validate_absolute_path($server_key_file) }
  if $client_cert_file { validate_absolute_path($client_cert_file) }
  if $client_key_file  { validate_absolute_path($client_key_file) }
  if $crl_file         { validate_absolute_path($crl_file) }

  if $dh_params {
    validate_re($dh_params, ['^512$', '^1024$', '^2048$', '^/.+'])
  }

  if $tls_srv_options {
    validate_re($tls_srv_options, [ '^V$', '^$', ])
  }

  concat::fragment { 'sendmail_mc-starttls':
    target  => 'sendmail.mc',
    order   => '47',
    content => template('sendmail/starttls.m4.erb'),
    notify  => Class['::sendmail::makeall'],
  }

  if $::sendmail_version != undef {
    if versioncmp($::sendmail_version, '8.15.1') < 0 {
      if $cipher_list {
        sendmail::mc::local_config { 'CipherList':
          content => "O CipherList=${cipher_list}\n",
        }
      }
      if $server_ssl_options {
        sendmail::mc::local_config { 'ServerSSLOptions':
          content => "O ServerSSLOptions=${server_ssl_options}\n",
        }
      }
      if $client_ssl_options {
        sendmail::mc::local_config { 'ClientSSLOptions':
          content => "O ClientSSLOptions=${client_ssl_options}\n",
        }
      }
    }
    else {
      if $cipher_list {
        sendmail::mc::define { 'confCIPHER_LIST':
          expansion => $cipher_list,
        }
      }
      if $server_ssl_options {
        sendmail::mc::define { 'confSERVER_SSL_OPTIONS':
          expansion => $server_ssl_options,
        }
      }
      if $client_ssl_options {
        sendmail::mc::define { 'confCLIENT_SSL_OPTIONS':
          expansion => $client_ssl_options,
        }
      }
    }
  }
}
