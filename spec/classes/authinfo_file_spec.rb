require 'spec_helper'

describe 'sendmail::authinfo::file' do

  context 'On Debian' do
    let(:title) { 'authinfo' }

    let :facts do
      { :operatingsystem => 'Debian' }
    end

    it do
      should contain_file('/etc/mail/authinfo').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'smmsp',
        'mode'   => '0640',
      })
    end
  end
end
