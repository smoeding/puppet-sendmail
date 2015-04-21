require 'spec_helper'

describe 'sendmail::relay_domains::file' do
  context 'On Debian' do
    let(:title) { 'relay_domains' }

    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    it {
      should contain_file('/etc/mail/relay-domains').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'smmsp',
        'mode'   => '0644',
      })
    }
  end
end
