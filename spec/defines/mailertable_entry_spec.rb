require 'spec_helper'

describe 'sendmail::mailertable::entry' do
  let(:title) { '.example.com' }

  context 'with value' do
    let(:params) do
      { :value => 'smtp:relay.example.com' }
    end

    it {
      should contain_class('sendmail::params')
      should contain_class('sendmail::makeall')
      should contain_class('sendmail::mailertable::file')
      should contain_augeas('/etc/mail/mailertable-.example.com') \
              .that_requires('Class[sendmail::mailertable::file]') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'without value' do
    let(:params) do
      { :ensure => 'present' }
    end

    it {
      expect {
        should compile
      }.to raise_error(/value must be set when creating/)
    }
  end
end
