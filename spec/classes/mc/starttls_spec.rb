require 'spec_helper'

describe 'sendmail::mc::starttls' do
  on_supported_os.each do |os, facts|
    context "on #{os} with defaults" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'Debian'
        it {
          is_expected.to contain_concat__fragment('sendmail_mc-starttls')
            .with_content(%r{^include.*starttls\.m4})
            .with_order('47')
        }
      else
        it {
          is_expected.to contain_concat__fragment('sendmail_mc-starttls')
            .without_content(%r{^include.*starttls\.m4})
            .with_order('47')
        }
      end
    end

    context "on #{os} with ca_cert_file => /foo" do
      let(:facts) { facts }

      let(:params) do
        { ca_cert_file: '/foo' }
      end

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-starttls')
          .with_content(%r{^define\(`confCACERT', `\/foo'\)dnl})
          .with_order('47')
      }
    end

    context "on #{os} with ca_cert_path => /foo" do
      let(:facts) { facts }

      let(:params) do
        { ca_cert_path: '/foo' }
      end

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-starttls')
          .with_content(%r{^define\(`confCACERT_PATH', `\/foo'\)dnl})
          .with_order('47')
      }
    end

    context "on #{os} with server_cert_file => /foo and server_key_file => /bar" do
      let(:facts) { facts }

      let(:params) do
        { server_cert_file: '/foo', server_key_file: '/bar' }
      end

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-starttls')
          .with_content(%r{^define\(`confSERVER_CERT', `\/foo'\)dnl})
          .with_content(%r{^define\(`confSERVER_KEY', `\/bar'\)dnl})
          .with_order('47')
      }
    end

    context "on #{os} with client_cert_file => /foo and client_key_file => /bar" do
      let(:facts) { facts }

      let(:params) do
        { client_cert_file: '/foo', client_key_file: '/bar' }
      end

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-starttls')
          .with_content(%r{^define\(`confCLIENT_CERT', `\/foo'\)dnl})
          .with_content(%r{^define\(`confCLIENT_KEY', `\/bar'\)dnl})
          .with_order('47')
      }
    end

    context "on #{os} with crl_file => /foo" do
      let(:facts) { facts }

      let(:params) do
        { crl_file: '/foo' }
      end

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-starttls')
          .with_content(%r{^define\(`confCRL', `\/foo'\)dnl})
          .with_order('47')
      }
    end

    context "on #{os} with dh_params => 512" do
      let(:facts) { facts }

      let(:params) do
        { dh_params: '512' }
      end

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-starttls')
          .with_content(%r{^define\(`confDH_PARAMETERS', `512'\)dnl})
          .with_order('47')
      }
    end

    context "on #{os} with dh_params => 1024" do
      let(:facts) { facts }

      let(:params) do
        { dh_params: '1024' }
      end

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-starttls')
          .with_content(%r{^define\(`confDH_PARAMETERS', `1024'\)dnl})
          .with_order('47')
      }
    end

    context "on #{os} with dh_params => 2048" do
      let(:facts) { facts }

      let(:params) do
        { dh_params: '2048' }
      end

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-starttls')
          .with_content(%r{^define\(`confDH_PARAMETERS', `2048'\)dnl})
          .with_order('47')
      }
    end

    context "on #{os} with dh_params => /foo" do
      let(:facts) { facts }

      let(:params) do
        { dh_params: '/foo' }
      end

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-starttls')
          .with_content(%r{^define\(`confDH_PARAMETERS', `\/foo'\)dnl})
          .with_order('47')
      }
    end

    context "on #{os} with tls_srv_options => V" do
      let(:facts) { facts }

      let(:params) do
        { tls_srv_options: 'V' }
      end

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-starttls')
          .with_content(%r{^define\(`confTLS_SRV_OPTIONS', `V'\)dnl})
          .with_order('47')
      }
    end

    context "on #{os} for sendmail 8.14 with cipher_list => foo" do
      let(:facts) { facts.merge(sendmail_version: '8.14.1') }

      let(:params) do
        { cipher_list: 'foo' }
      end

      it {
        is_expected.to contain_sendmail__mc__local_config('CipherList')
          .with_content(%r{^O CipherList=foo$})
      }
    end

    context "on #{os} for sendmail 8.15 with cipher_list => foo" do
      let(:facts) { facts.merge(sendmail_version: '8.15.1') }

      let(:params) do
        { cipher_list: 'foo' }
      end

      it {
        is_expected.to contain_sendmail__mc__define('confCIPHER_LIST')
          .with_expansion(%r{^foo$})
      }
    end

    context "on #{os} for sendmail 8.14 with server_ssl_options => foo" do
      let(:facts) { facts.merge(sendmail_version: '8.14.1') }

      let(:params) do
        { server_ssl_options: 'foo' }
      end

      it {
        is_expected.to contain_sendmail__mc__local_config('ServerSSLOptions')
          .with_content(%r{^O ServerSSLOptions=foo$})
      }
    end

    context "on #{os} for sendmail 8.15 with server_ssl_options => foo" do
      let(:facts) { facts.merge(sendmail_version: '8.15.1') }

      let(:params) do
        { server_ssl_options: 'foo' }
      end

      it {
        is_expected.to contain_sendmail__mc__define('confSERVER_SSL_OPTIONS')
          .with_expansion(%r{^foo$})
      }
    end

    context "on #{os} for sendmail 8.14 with client_ssl_options => foo" do
      let(:facts) { facts.merge(sendmail_version: '8.14.1') }

      let(:params) do
        { client_ssl_options: 'foo' }
      end

      it {
        is_expected.to contain_sendmail__mc__local_config('ClientSSLOptions')
          .with_content(%r{^O ClientSSLOptions=foo$})
      }
    end

    context "on #{os} for sendmail 8.15 with client_ssl_options => foo" do
      let(:facts) { facts.merge(sendmail_version: '8.15.1') }

      let(:params) do
        { client_ssl_options: 'foo' }
      end

      it {
        is_expected.to contain_sendmail__mc__define('confCLIENT_SSL_OPTIONS')
          .with_expansion(%r{^foo$})
      }
    end
  end
end
