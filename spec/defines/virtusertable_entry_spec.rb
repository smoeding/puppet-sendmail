require 'spec_helper'

describe 'sendmail::virtusertable::entry' do
  let(:title) { 'info@example.com' }

  let(:params) do
    { :value => 'fred' }
  end

  let(:facts) do
    { :operatingsystem => 'Debian' }
  end

  it do
    should contain_augeas('/etc/mail/virtusertable-info@example.com') \
            .that_requires('Class[sendmail::virtusertable::file]') \
            .that_notifies('Class[sendmail::makeall]')
  end

  context 'Missing value' do
    let(:params) { { :ensure => 'present' } }

    it do
      expect {
        should compile
      }.to raise_error(/value must be set when creating an virtusertable entry/)
    end
  end
end
