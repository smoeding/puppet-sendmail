require 'spec_helper'

describe 'sendmail::userdb::entry' do
  let(:title) { 'fred:maildrop' }

  let(:params) do
    { :value => 'fred@example.org' }
  end

  let(:facts) do
    { :operatingsystem => 'Debian' }
  end

  it do
    should contain_augeas('/etc/mail/userdb-fred:maildrop') \
            .that_requires('Class[sendmail::userdb::file]') \
            .that_notifies('Class[sendmail::makeall]')
  end

  context 'Missing value' do
    let(:params) { { :ensure => 'present' } }

    it do
      expect {
        should compile
      }.to raise_error(/value must be set when creating an userdb entry/)
    end
  end
end
