require 'spec_helper'

describe 'sendmail::genericstable::file' do

  context 'On Debian' do
    let(:title) { 'genericstable' }

    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    it do
      should contain_file('/etc/mail/genericstable').with({
        'ensure' => 'file',
        'owner'  => 'smmta',
        'group'  => 'smmsp',
        'mode'   => '0640',
      })
    end
  end
end
