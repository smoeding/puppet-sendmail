require 'spec_helper'

describe 'sendmail::access::file' do

  it { should contain_class('sendmail::access::file') }

  context 'On Debian' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    it {
      should contain_file('/etc/mail/access').with(
               'ensure' => 'file',
               'owner'  => 'smmta',
               'group'  => 'smmsp',
               'mode'   => '0640',
             )
    }
  end
end
