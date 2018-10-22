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
  Optional[Stdlib::Absolutepath] $ca_cert_file       = undef,
  Optional[Stdlib::Absolutepath] $ca_cert_path       = undef,
  Optional[Stdlib::Absolutepath] $server_cert_file   = undef,
  Optional[Stdlib::Absolutepath] $server_key_file    = undef,
  Optional[Stdlib::Absolutepath] $client_cert_file   = undef,
  Optional[Stdlib::Absolutepath] $client_key_file    = undef,
  Optional[Stdlib::Absolutepath] $crl_file           = undef,
  Optional[Sendmail::DHParam]    $dh_params          = undef,
  Optional[Enum['V']]            $tls_srv_options    = undef,
  Optional[String]               $cipher_list        = undef,
  Optional[String]               $server_ssl_options = undef,
  Optional[String]               $client_ssl_options = undef,
) {
  concat::fragment { 'sendmail_mc-starttls':
    target  => 'sendmail.mc',
    order   => '47',
    content => template('sendmail/starttls.m4.erb'),
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
