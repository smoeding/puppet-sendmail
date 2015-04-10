require 'spec_helper'

describe 'sendmail::access::file' do

  context 'On Debian' do
    let(:title) { 'access' }

    let :facts do
      { :operatingsystem => 'Debian' }
    end

    it do
      should contain_file('/etc/mail/access').with({
        'ensure' => 'file',
        'owner'  => 'smmta',
        'group'  => 'smmsp',
        'mode'   => '0640',
      })
    end
  end
end
