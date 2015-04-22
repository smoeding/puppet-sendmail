require 'spec_helper'

describe 'sendmail::trusted_users::file' do

  context 'On Debian' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    it {
      should contain_file('/etc/mail/trusted-users').with(
               'ensure' => 'file',
               'owner'  => 'root',
               'group'  => 'smmsp',
               'mode'   => '0644',
             )
    }
  end
end
