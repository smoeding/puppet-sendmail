require 'spec_helper'

describe 'sendmail::genericstable::file' do

  it { should contain_class('sendmail::genericstable::file') }

  context 'On Debian' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    it {
      should contain_file('/etc/mail/genericstable').with(
               'ensure' => 'file',
               'owner'  => 'smmta',
               'group'  => 'smmsp',
               'mode'   => '0640',
             )
    }
  end
end
