require 'spec_helper'

describe 'sendmail::domaintable::file' do

  context 'On Debian' do
    let(:title) { 'domaintable' }

    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    it do
      should contain_file('/etc/mail/domaintable').with({
        'ensure' => 'file',
        'owner'  => 'smmta',
        'group'  => 'smmsp',
        'mode'   => '0640',
      })
    end
  end
end
