require 'spec_helper'

describe 'sendmail::trustedusers::file' do
  context 'On Debian' do
    let(:title) { 'trustedusers' }

    let :facts do
      { :osfamily => 'Debian' }
    end

    it do
      should contain_file('/etc/mail/trusted-users').with({
        'ensure' => 'file',
        'owner'  => 'smmta',
        'group'  => 'smmsp',
        'mode'   => '0640',
      })
    end
  end
end
