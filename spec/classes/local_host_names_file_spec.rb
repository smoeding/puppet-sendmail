require 'spec_helper'

describe 'sendmail::local_host_names::file' do

  context 'On Debian' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    it {
      should contain_file('/etc/mail/local-host-names').with(
               'ensure' => 'file',
               'owner'  => 'root',
               'group'  => 'smmsp',
               'mode'   => '0644',
             )
    }
  end
end
