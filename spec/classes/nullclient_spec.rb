require 'spec_helper'

describe 'sendmail::nullclient' do

  context 'with mail_hub => example.com' do
    let(:params) do
      { :mail_hub => 'example.com' }
    end

    it { should contain_class('sendmail::nullclient') }

    it {
      should contain_class('sendmail').with(
               'dont_probe_interfaces' => true,
               'enable_ipv4_daemon'    => false,
               'enable_ipv6_daemon'    => false,
               'enable_access_db'      => false,
               'mailers'               => []
             )

      should contain_sendmail__mc__feature('no_default_msa')

      should contain_sendmail__mc__daemon_options('MTA').with(
               'family' => 'inet',
               'addr'   => '127.0.0.1',
               'port'   => '587'
             )

      should contain_sendmail__mc__feature('nullclient').with(
               'args' => [ 'example.com' ]
             )
    }
  end
end
