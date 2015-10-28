require 'spec_helper'

describe 'sendmail::virtusertable::file' do

  it { should contain_class('sendmail::virtusertable::file') }

  context 'On Debian' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    it {
      should contain_file('/etc/mail/virtusertable').with(
               'ensure' => 'file',
               'owner'  => 'smmta',
               'group'  => 'smmsp',
               'mode'   => '0640',
             )
    }
  end
end
