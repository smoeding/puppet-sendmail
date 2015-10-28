require 'spec_helper'

describe 'sendmail::aliases::newaliases' do

  it { should contain_class('sendmail::aliases::newaliases') }

  context 'On Debian' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    it {
      should contain_exec('sendmail::aliases::newaliases').with(
               'command'     => '/usr/sbin/sendmail -bi',
               'refreshonly' => 'true',
             )
    }
  end
end
