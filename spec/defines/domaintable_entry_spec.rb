require 'spec_helper'

describe 'sendmail::domaintable::entry' do
  let(:title) { 'example.com' }

  let(:params) do
    { :value => 'example.org' }
  end

  let(:facts) do
    { :operatingsystem => 'Debian' }
  end

  it do
    should contain_augeas('/etc/mail/domaintable-example.com') \
            .that_requires('Class[sendmail::domaintable::file]') \
            .that_notifies('Class[sendmail::makeall]')
  end

  context 'Missing value' do
    let(:params) { { :ensure => 'present' } }

    it do
      expect {
        should compile
      }.to raise_error(/value must be set when creating an domaintable entry/)
    end
  end
end
