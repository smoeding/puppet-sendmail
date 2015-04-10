require 'spec_helper'

describe 'sendmail::relaydomains::file' do
  context 'On Debian' do
    let(:title) { 'relaydomains' }

    let :facts do
      { :operatingsystem => 'Debian' }
    end

    it do
      should contain_file('/etc/mail/relay-domains').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'smmsp',
        'mode'   => '0644',
      })
    end
  end
end
