require 'spec_helper'

describe 'sendmail::genericstable::entry' do
  let(:title) { 'user@example.com' }

  let(:params) do
    { :value => 'user@example.org' }
  end

  let(:facts) do
    { :operatingsystem => 'Debian' }
  end

  it {
    should contain_augeas('/etc/mail/genericstable-user@example.com') \
            .that_requires('Class[sendmail::genericstable::file]') \
            .that_notifies('Class[sendmail::makeall]')
  }

  context 'Missing value' do
    let(:params) { { :ensure => 'present' } }

    it {
      expect {
        should compile
      }.to raise_error(/value must be set when creating an genericstable entry/)
    }
  end
end
