require 'spec_helper'

describe 'sendmail::domaintable::entry' do
  let(:title) { 'example.com' }

  context 'with value' do
    let(:params) do
      { :value => 'example.org' }
    end

    it {
      should contain_class('sendmail::params')
      should contain_class('sendmail::makeall')
      should contain_class('sendmail::domaintable::file')
      should contain_augeas('/etc/mail/domaintable-example.com') \
              .that_requires('Class[sendmail::domaintable::file]') \
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
