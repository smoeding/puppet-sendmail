require 'spec_helper'

describe 'sendmail::userdb::entry' do
  let(:title) { 'fred:maildrop' }

  context 'with value' do
    let(:params) do
      { :value => 'fred@example.org' }
    end

    it {
      should contain_class('sendmail::params')
      should contain_class('sendmail::makeall')
      should contain_class('sendmail::userdb::file')
      should contain_augeas('/etc/mail/userdb-fred:maildrop') \
              .that_requires('Class[sendmail::userdb::file]') \
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
