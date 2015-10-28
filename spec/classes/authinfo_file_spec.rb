require 'spec_helper'

describe 'sendmail::authinfo::file' do

  it { should contain_class('sendmail::authinfo::file') }

  context 'On Debian' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    it {
      should contain_file('/etc/mail/authinfo').with(
               'ensure' => 'file',
               'owner'  => 'root',
               'group'  => 'smmsp',
               'mode'   => '0640',
             )
    }
  end
end
