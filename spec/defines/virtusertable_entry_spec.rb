require 'spec_helper'

describe 'sendmail::virtusertable::entry' do
  let(:title) { 'info@example.com' }

  let(:facts) do
    { :operatingsystem => 'Debian' }
  end

  let(:params) do
    { :value => 'fred' }
  end

  it {
    should contain_class('sendmail::params')
    should contain_class('sendmail::makeall')
    should contain_class('sendmail::virtusertable::file')
    should contain_augeas('/etc/mail/virtusertable-info@example.com') \
            .that_requires('Class[sendmail::virtusertable::file]') \
            .that_notifies('Class[sendmail::makeall]')
  }

  context 'Missing value' do
    let(:params) do
      { :ensure => 'present' }
    end

    it {
      expect {
        should compile
      }.to raise_error(/value must be set when creating an virtusertable entry/)
    }
  end
end
