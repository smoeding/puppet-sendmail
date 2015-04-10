require 'spec_helper'

describe 'sendmail::localhostnames::file' do
  context 'On Debian' do
    let(:title) { 'localhostnames' }

    let :facts do
      { :operatingsystem => 'Debian' }
    end

    it do
      should contain_file('/etc/mail/local-host-names').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'smmsp',
        'mode'   => '0644',
      })
    end
  end
end
