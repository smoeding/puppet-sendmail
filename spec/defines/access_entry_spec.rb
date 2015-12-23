require 'spec_helper'

describe 'sendmail::access::entry' do
  let(:title) { 'example.com' }

  context 'with value' do
    let(:params) do
      { :value => 'REJECT' }
    end

    it {
      should contain_class('sendmail::params')
      should contain_class('sendmail::makeall')
      should contain_class('sendmail::access::file')
      should contain_augeas('/etc/mail/access-example.com') \
              .that_requires('Class[sendmail::access::file]') \
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
