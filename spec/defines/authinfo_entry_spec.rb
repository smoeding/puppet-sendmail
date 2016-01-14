require 'spec_helper'

describe 'sendmail::authinfo::entry' do
  let(:title) { 'example.com' }

  context 'with authorization_id and password' do
    let(:params) do
      {
        :password         => 'secret',
        :authorization_id => 'authuser'
      }
    end

    it {
      should contain_class('sendmail::params')
      should contain_class('sendmail::makeall')
      should contain_class('sendmail::authinfo::file')
      should contain_augeas('/etc/mail/authinfo-AuthInfo:example.com') \
              .that_requires('Class[sendmail::authinfo::file]') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

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
      should contain_augeas('/etc/mail/authinfo-AuthInfo:example.com') \
              .that_requires('Class[sendmail::authinfo::file]') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with authorization_id and password_base64' do
    let(:params) do
      {
        :password_base64  => 'secret',
        :authorization_id => 'authuser'
      }
    end

    it {
      should contain_class('sendmail::params')
      should contain_class('sendmail::makeall')
      should contain_class('sendmail::authinfo::file')
      should contain_augeas('/etc/mail/authinfo-AuthInfo:example.com') \
              .that_requires('Class[sendmail::authinfo::file]') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with authentication_id and password_base64' do
    let(:params) do
      {
        :password_base64   => 'secret',
        :authentication_id => 'authuser'
      }
    end

    it {
      should contain_class('sendmail::params')
      should contain_class('sendmail::makeall')
      should contain_class('sendmail::authinfo::file')
      should contain_augeas('/etc/mail/authinfo-AuthInfo:example.com') \
              .that_requires('Class[sendmail::authinfo::file]') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'without authentication_id and authorization_id' do
    let(:params) do
      { :password => 'secret' }
    end

    it {
      expect {
        should compile
      }.to raise_error(/authorization_id or authentication_id or both/)
    }
  end

  context 'without password and password_base64' do
    let(:params) do
      { :authorization_id => 'authuser' }
    end

    it {
      expect {
        should compile
      }.to raise_error(/Either password or password_base64 must be set/)
    }
  end

  context 'with password and password_base64' do
    let(:params) do
      {
        :password         => 'secret',
        :password_base64  => 'secret',
        :authorization_id => 'authuser'
      }
    end

    it {
      expect {
        should compile
      }.to raise_error(/Only one of password and password_base64 can be set/)
    }
  end
end
