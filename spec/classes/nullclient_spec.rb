require 'spec_helper'

describe 'sendmail::nullclient' do

  context 'with mail_hub => example.com' do
    let(:params) do
      { :mail_hub => 'example.com' }
    end

    it {
      should contain_class('sendmail::nullclient')
      should contain_class('sendmail').with(
               'dont_probe_interfaces' => true,
               'enable_ipv4_daemon'    => false,
               'enable_ipv6_daemon'    => false,
               'mailers'               => [],
               'ca_cert_file'          => nil,
               'ca_cert_path'          => nil,
               'server_cert_file'      => nil,
               'server_key_file'       => nil,
               'client_cert_file'      => nil,
               'client_key_file'       => nil,
               'crl_file'              => nil,
               'dh_params'             => nil,
               'tls_srv_options'       => nil,
               'cipher_list'           => nil,
               'server_ssl_options'    => nil,
               'client_ssl_options'    => nil,
             )

      should contain_sendmail__mc__feature('no_default_msa')

      should contain_sendmail__mc__daemon_options('MSA').with(
               'family' => 'inet',
               'addr'   => '127.0.0.1',
               'port'   => '587',
               'modify' => nil,
             )

      should contain_sendmail__mc__feature('nullclient').with(
               'args' => [ 'example.com' ]
             )
    }
  end

  context "with port => 25" do
    let(:params) do
      { :port => '25', :mail_hub => 'example.com' }
    end

    it {
      should contain_sendmail__mc__daemon_options('MSA').with('port' => '25')
    }
  end

  context "with port => foo" do
    let(:params) do
      { :port => 'foo', :mail_hub => 'example.com' }
    end

    it {
      expect { should compile }.to raise_error(/does not match/)
    }
  end

  context "with port_option_modify => S" do
    let(:params) do
      { :port_option_modify => 'S', :mail_hub => 'example.com' }
    end

    it {
      should contain_sendmail__mc__daemon_options('MSA').with('modify' => 'S')
    }
  end

  context "with port_option_modify => X" do
    let(:params) do
      { :port_option_modify => 'X', :mail_hub => 'example.com' }
    end

    it {
      expect { should compile }.to raise_error(/does not match/)
    }
  end

  context "with tls_srv_options => V" do
    let(:params) do
      { :tls_srv_options => 'V', :mail_hub => 'example.com' }
    end

    it {
      should contain_class('sendmail').with('tls_srv_options' => 'V')
    }
  end

  [ 'ca_cert_file', 'ca_cert_path',
    'server_cert_file', 'server_key_file',
    'client_cert_file', 'client_key_file',
    'crl_file', 'dh_params', 'cipher_list',
    'server_ssl_options', 'client_ssl_options' ].each do |parameter|

    context "with #{parameter} defined" do
      let(:params) do
        { parameter.to_sym => '/foo', :mail_hub => 'example.com' }
      end

      it {
        should contain_class('sendmail').with(parameter => '/foo')
      }
    end
  end
end
