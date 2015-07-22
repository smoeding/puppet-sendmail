require 'spec_helper'

describe 'sendmail::nullclient' do

  context 'On Debian with mail_hub => example.com' do
    let(:params) do
      { :mail_hub => 'example.com' }
    end

    it {
      should contain_class('sendmail').with(
               'dont_probe_interfaces' => true,
               'enable_ipv4_daemon'    => false,
               'enable_ipv6_daemon'    => false,
               'enable_access_db'      => false)

      should contain_sendmail__mc__feature('nullclient') \
              .with_args([ 'example.com' ])
    }
  end
end
