require 'spec_helper'

describe 'sendmail::aliases::entry' do
  let(:title) { 'fred' }

  let(:params) do
    { :recipient => 'fred@example.org' }
  end

  let(:facts) do
    { 'operatingsystem' => 'Debian' }
  end

  it do
    should contain_mailalias('fred') \
            .that_requires('Class[sendmail::aliases::file]') \
            .that_notifies('Class[sendmail::aliases::newaliases]')
  end

  context 'Create alias' do
    let(:params) { { :recipient => 'fred@example.org' } }

    it do
      should contain_mailalias('fred').with({
        'ensure'    => 'present',
        'recipient' => 'fred@example.org',
      })
    end
  end

  context 'Remove alias' do
    let(:params) { { :ensure => 'absent' } }

    it do
      should contain_mailalias('fred').with({
        'ensure' => 'absent'
      })
    end
  end

  context 'Missing recipient' do
    let(:params) { { :ensure => 'present' } }

    it do
      expect {
        should compile
      }.to raise_error(/recipient must be set when creating an alias/)
    end
  end
end
