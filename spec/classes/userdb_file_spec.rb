require 'spec_helper'

describe 'sendmail::userdb::file' do

  it { should contain_class('sendmail::userdb::file') }

  context 'On Debian' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    it {
      should contain_file('/etc/mail/userdb').with(
               'ensure' => 'file',
               'owner'  => 'smmta',
               'group'  => 'smmsp',
               'mode'   => '0640',
             )
    }
  end
end
