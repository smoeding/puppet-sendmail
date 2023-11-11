require 'spec_helper'

describe 'sendmail::nullclient' do
  on_supported_os.each do |os, facts|
    context "on #{os} with mail_hub => example.com" do
      let(:facts) { facts }
      let(:params) do
        { mail_hub: 'example.com' }
      end

      it {
        is_expected.to contain_class('sendmail::nullclient')
        is_expected.to contain_class('sendmail')
          .without_domain_name
          .without_max_message_size
          .with_dont_probe_interfaces(true)
          .with_enable_ipv4_daemon(false)
          .with_enable_ipv6_daemon(false)
          .with_mailers([])
          .with_trusted_users([])
          .with_enable_msp_trusted_users(false)
          .without_ca_cert_file
          .without_ca_cert_path
          .without_server_cert_file
          .without_server_key_file
          .without_client_cert_file
          .without_client_key_file
          .without_crl_file
          .without_dh_params
          .without_tls_srv_options
          .without_cipher_list
          .without_server_ssl_options
          .without_client_ssl_options

        is_expected.to contain_sendmail__mc__feature('no_default_msa')

        is_expected.to contain_sendmail__mc__daemon_options('MSA-v4')
          .with_daemon_name('MSA')
          .with_family('inet')
          .with_addr('127.0.0.1')
          .with_port('587')
          .without_modify

        is_expected.to contain_sendmail__mc__daemon_options('MSA-v6')
          .with_daemon_name('MSA')
          .with_family('inet6')
          .with_addr('::1')
          .with_port('587')
          .without_modify

        is_expected.to contain_sendmail__mc__feature('nullclient')
          .with_args(['example.com'])
      }
    end

    context "on #{os} with enable_ipv4_msa => false" do
      let(:facts) { facts }
      let(:params) do
        { enable_ipv4_msa: false, mail_hub: 'example.com' }
      end

      it {
        is_expected.not_to contain_sendmail__mc__daemon_options('MSA-v4')
        is_expected.to contain_sendmail__mc__daemon_options('MSA-v6')
      }
    end

    context "on #{os} with enable_ipv6_msa => false" do
      let(:facts) { facts }
      let(:params) do
        { enable_ipv6_msa: false, mail_hub: 'example.com' }
      end

      it {
        is_expected.to contain_sendmail__mc__daemon_options('MSA-v4')
        is_expected.not_to contain_sendmail__mc__daemon_options('MSA-v6')
      }
    end

    context "on #{os} with enable_ipv6_msa => false, enable_ipv6_msa => false" do
      let(:facts) { facts }
      let(:params) do
        {
          enable_ipv4_msa: false,
          enable_ipv6_msa: false,
          mail_hub:        'example.com',
        }
      end

      it {
        is_expected.to compile.and_raise_error(%r{enabled for IPv4 or IPv6})
      }
    end

    context "on #{os} with port => 25" do
      let(:facts) { facts }
      let(:params) do
        { port: '25', mail_hub: 'example.com' }
      end

      it {
        is_expected.to contain_sendmail__mc__daemon_options('MSA-v4').with_port('25')
        is_expected.to contain_sendmail__mc__daemon_options('MSA-v6').with_port('25')
      }
    end

    context "on #{os} with port_option_modify => S" do
      let(:facts) { facts }
      let(:params) do
        { port_option_modify: 'S', mail_hub: 'example.com' }
      end

      it {
        is_expected.to contain_sendmail__mc__daemon_options('MSA-v4').with_modify('S')
        is_expected.to contain_sendmail__mc__daemon_options('MSA-v6').with_modify('S')
      }
    end

    context "on #{os} with port_option_modify => Sa" do
      let(:facts) { facts }
      let(:params) do
        { port_option_modify: 'Sa', mail_hub: 'example.com' }
      end

      it {
        is_expected.to contain_sendmail__mc__daemon_options('MSA-v4').with_modify('Sa')
        is_expected.to contain_sendmail__mc__daemon_options('MSA-v6').with_modify('Sa')
      }
    end

    context "on #{os} with domain_name => smtp.example.com" do
      let(:facts) { facts }
      let(:params) do
        { domain_name: 'smtp.example.com', mail_hub: 'example.com' }
      end

      it {
        is_expected.to contain_class('sendmail').with_domain_name('smtp.example.com')
      }
    end

    context "on #{os} with max_message_size => 42" do
      let(:facts) { facts }
      let(:params) do
        { max_message_size: '42', mail_hub: 'example.com' }
      end

      it {
        is_expected.to contain_class('sendmail').with_max_message_size('42')
      }
    end

    context "on #{os} with tls_srv_options => V" do
      let(:facts) { facts }
      let(:params) do
        { tls_srv_options: 'V', mail_hub: 'example.com' }
      end

      it {
        is_expected.to contain_class('sendmail').with_tls_srv_options('V')
      }
    end

    context "on #{os} with enable_msp_trusted_users => true" do
      let(:facts) { facts }
      let(:params) do
        { enable_msp_trusted_users: true, mail_hub: 'example.com' }
      end

      it {
        is_expected.to contain_class('sendmail').with_enable_msp_trusted_users(true)
      }
    end

    context "on #{os} with trusted_users => [ 'root' ]" do
      let(:facts) { facts }
      let(:params) do
        { trusted_users: ['root'], mail_hub: 'example.com' }
      end

      it {
        is_expected.to contain_class('sendmail').with_trusted_users(['root'])
      }
    end

    ['ca_cert_file', 'ca_cert_path',
     'server_cert_file', 'server_key_file',
     'client_cert_file', 'client_key_file',
     'crl_file', 'dh_params', 'cipher_list',
     'server_ssl_options', 'client_ssl_options'].each do |parameter|
      context "on #{os} with #{parameter} defined" do
        let(:facts) { facts }
        let(:params) do
          { parameter.to_sym => '/foo', mail_hub: 'example.com' }
        end

        it {
          is_expected.to contain_class('sendmail').with(parameter => '/foo')
        }
      end
    end
  end
end
