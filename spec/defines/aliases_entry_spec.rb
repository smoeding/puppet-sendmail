require 'spec_helper'

describe 'sendmail::aliases::entry' do
  let(:title) { 'fred' }

  let(:facts) do
    { :operatingsystem => 'Debian' }
  end

  let(:params) do
    { :recipient => 'fred@example.org' }
  end

  it {
    should contain_mailalias('fred') \
            .that_requires('Class[sendmail::aliases::file]') \
            .that_notifies('Class[sendmail::aliases::newaliases]')
  }

  context 'Create alias' do
    let(:params) { { :recipient => 'fred@example.org' } }

    it {
      should contain_mailalias('fred').with(
               'ensure'    => 'present',
               'recipient' => 'fred@example.org',
             )
    }
  end

  context 'Remove alias' do
    let(:params) { { :ensure => 'absent' } }

    it {
      should contain_mailalias('fred').with_ensure('absent')
    }
  end

  context 'Missing recipient' do
    let(:params) { { :ensure => 'present' } }

    it {
      expect {
        should compile
      }.to raise_error(/recipient must be set when creating an alias/)
    }
  end
end
