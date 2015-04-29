require 'spec_helper'

describe 'sendmail::mailertable::entry' do
  let(:title) { '.example.com' }

  let(:facts) do
    { :operatingsystem => 'Debian' }
  end

  let(:params) do
    { :value => 'smtp:relay.example.com' }
  end

  it {
    should contain_augeas('/etc/mail/mailertable-.example.com') \
            .that_requires('Class[sendmail::mailertable::file]') \
            .that_notifies('Class[sendmail::makeall]')
  }

  context 'Missing value' do
    let(:params) do
      { :ensure => 'present' }
    end

    it {
      expect {
        should compile
      }.to raise_error(/value must be set when creating an mailertable entry/)
    }
  end
end
