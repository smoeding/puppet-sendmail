require 'spec_helper'

describe 'sendmail::userdb::entry' do
  let(:title) { 'fred:maildrop' }

  let(:facts) do
    { :operatingsystem => 'Debian' }
  end

  let(:params) do
    { :value => 'fred@example.org' }
  end

  it {
    should contain_augeas('/etc/mail/userdb-fred:maildrop') \
            .that_requires('Class[sendmail::userdb::file]') \
            .that_notifies('Class[sendmail::makeall]')
  }

  context 'Missing value' do
    let(:params) do
      { :ensure => 'present' }
    end

    it {
      expect {
        should compile
      }.to raise_error(/value must be set when creating an userdb entry/)
    }
  end
end
