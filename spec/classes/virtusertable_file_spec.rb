require 'spec_helper'

describe 'sendmail::virtusertable::file' do

  context 'On Debian' do
    let(:title) { 'virtusertable' }

    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    it do
      should contain_file('/etc/mail/virtusertable').with({
        'ensure' => 'file',
        'owner'  => 'smmta',
        'group'  => 'smmsp',
        'mode'   => '0640',
      })
    end
  end
end
