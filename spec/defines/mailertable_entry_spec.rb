require 'spec_helper'

describe 'sendmail::mailertable::entry' do
  let(:title) { '.example.com' }

  let(:params) do
    { :value => 'smtp:relay.example.com' }
  end

  let(:facts) do
    { :operatingsystem => 'Debian' }
  end

  it do
    should contain_augeas('/etc/mail/mailertable-.example.com') \
            .that_requires('Class[sendmail::mailertable::file]') \
            .that_notifies('Class[sendmail::makeall]')
  end

  context 'Missing value' do
    let(:params) { { :ensure => 'present' } }

    it do
      expect {
        should compile
      }.to raise_error(/value must be set when creating an mailertable entry/)
    end
  end
end
