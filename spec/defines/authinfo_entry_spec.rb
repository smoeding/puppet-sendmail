require 'spec_helper'

describe 'sendmail::authinfo::entry' do
  let(:title) { 'example.com' }

  context 'with authentication_id and password' do
    let(:params) do
      {
        :password          => 'secret',
        :authentication_id => 'authuser'
      }
    end

    it {
      should contain_class('sendmail::params')
      should contain_class('sendmail::makeall')
      should contain_class('sendmail::authinfo::file')
      should contain_augeas('/etc/mail/authinfo-example.com') \
              .that_requires('Class[sendmail::authinfo::file]') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'without authentication_id and authorization_id' do
    let(:params) do
      { :password => 'secret', }
    end

    it {
      expect {
        should compile
      }.to raise_error(/authorization_id or authentication_id or both/)
    }
  end
end
