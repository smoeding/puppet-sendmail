require 'spec_helper'

describe 'sendmail::trustedusers::file' do
  context 'On Debian' do
    let(:title) { 'trustedusers' }

    let :facts do
      { :operatingsystem => 'Debian' }
    end

    it do
      should contain_file('/etc/mail/trusted-users').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'smmsp',
        'mode'   => '0644',
      })
    end
  end
end
