require 'spec_helper'

describe 'sendmail::mc::starttls' do
  let(:title) { 'foo' }

  context 'with defaults' do
    it {
      should contain_concat__fragment('sendmail_mc-starttls') \
              .with_content(/^include.*starttls.m4/) \
              .with_order('47') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with ca_cert_file => /foo' do
    let(:params) do
      { :ca_cert_file => '/foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-starttls') \
              .with_content(/^define\(`confCACERT', `\/foo'\)dnl/)
    }
  end

  context 'with ca_cert_path => /foo' do
    let(:params) do
      { :ca_cert_path => '/foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-starttls') \
              .with_content(/^define\(`confCACERT_PATH', `\/foo'\)dnl/)
    }
  end

  context 'with server_cert_file => /foo and server_key_file => /bar' do
    let(:params) do
      { :server_cert_file => '/foo', :server_key_file => '/bar' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-starttls') \
              .with_content(/^define\(`confSERVER_CERT', `\/foo'\)dnl/) \
              .with_content(/^define\(`confSERVER_KEY', `\/bar'\)dnl/)
    }
  end

  context 'with client_cert_file => /foo and client_key_file => /bar' do
    let(:params) do
      { :client_cert_file => '/foo', :client_key_file => '/bar' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-starttls') \
              .with_content(/^define\(`confCLIENT_CERT', `\/foo'\)dnl/) \
              .with_content(/^define\(`confCLIENT_KEY', `\/bar'\)dnl/)
    }
  end

  context 'with crl_file => /foo' do
    let(:params) do
      { :crl_file => '/foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-starttls') \
              .with_content(/^define\(`confCRL', `\/foo'\)dnl/)
    }
  end

  context 'with dh_params => 512' do
    let(:params) do
      { :dh_params => '512' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-starttls') \
              .with_content(/^define\(`confDH_PARAMETERS', `512'\)dnl/)
    }
  end

  context 'with dh_params => 1024' do
    let(:params) do
      { :dh_params => '1024' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-starttls') \
              .with_content(/^define\(`confDH_PARAMETERS', `1024'\)dnl/)
    }
  end

  context 'with dh_params => /foo' do
    let(:params) do
      { :dh_params => '/foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-starttls') \
              .with_content(/^define\(`confDH_PARAMETERS', `\/foo'\)dnl/)
    }
  end

  context 'with tls_srv_options => V' do
    let(:params) do
      { :tls_srv_options => 'V' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-starttls') \
              .with_content(/^define\(`confTLS_SRV_OPTIONS', `V'\)dnl/)
    }
  end

  context 'with cipher_list => foo' do
    let(:params) do
      { :cipher_list => 'foo' }
    end

    it {
      should contain_sendmail__mc__local_config('CipherList') \
              .with_content(/^O CipherList=foo$/)
    }
  end

  context 'with server_ssl_options => foo' do
    let(:params) do
      { :server_ssl_options => 'foo' }
    end

    it {
      should contain_sendmail__mc__local_config('ServerSSLOptions') \
              .with_content(/^O ServerSSLOptions=foo$/)
    }
  end

  context 'with client_ssl_options => foo' do
    let(:params) do
      { :client_ssl_options => 'foo' }
    end

    it {
      should contain_sendmail__mc__local_config('ClientSSLOptions') \
              .with_content(/^O ClientSSLOptions=foo$/)
    }
  end
end
