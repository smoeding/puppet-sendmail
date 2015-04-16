require 'spec_helper'

describe 'sendmail::userdb::file' do

  context 'On Debian' do
    let(:title) { 'userdb' }

    let :facts do
      { :operatingsystem => 'Debian' }
    end

    it do
      should contain_file('/etc/mail/userdb').with({
        'ensure' => 'file',
        'owner'  => 'smmta',
        'group'  => 'smmsp',
        'mode'   => '0640',
      })
    end
  end
end
