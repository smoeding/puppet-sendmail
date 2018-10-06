require 'spec_helper'

describe 'sendmail::authinfo::entry' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    let(:title) { 'example.com' }
    let(:pre_condition) { 'include sendmail::service' }

    context "on #{os} with authorization_id and password" do
      let(:params) do
        { password: 'secret', authorization_id: 'authuser' }
      end

      it {
        is_expected.to contain_class('sendmail::params')
        is_expected.to contain_class('sendmail::makeall')
        is_expected.to contain_class('sendmail::authinfo::file')
        is_expected.to contain_augeas('/etc/mail/authinfo-AuthInfo:example.com') \
          .that_requires('Class[sendmail::authinfo::file]') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with authentication_id and password" do
      let(:params) do
        { password: 'secret', authentication_id: 'authuser' }
      end

      it {
        is_expected.to contain_class('sendmail::params')
        is_expected.to contain_class('sendmail::makeall')
        is_expected.to contain_class('sendmail::authinfo::file')
        is_expected.to contain_augeas('/etc/mail/authinfo-AuthInfo:example.com') \
          .that_requires('Class[sendmail::authinfo::file]') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with authorization_id and password_base64" do
      let(:params) do
        { password_base64: 'secret', authorization_id: 'authuser' }
      end

      it {
        is_expected.to contain_class('sendmail::params')
        is_expected.to contain_class('sendmail::makeall')
        is_expected.to contain_class('sendmail::authinfo::file')
        is_expected.to contain_augeas('/etc/mail/authinfo-AuthInfo:example.com') \
          .that_requires('Class[sendmail::authinfo::file]') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with authentication_id and password_base64" do
      let(:params) do
        { password_base64: 'secret', authentication_id: 'authuser' }
      end

      it {
        is_expected.to contain_class('sendmail::params')
        is_expected.to contain_class('sendmail::makeall')
        is_expected.to contain_class('sendmail::authinfo::file')
        is_expected.to contain_augeas('/etc/mail/authinfo-AuthInfo:example.com') \
          .that_requires('Class[sendmail::authinfo::file]') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context 'on #{os} without authentication_id and authorization_id' do
      let(:params) do
        { password: 'secret' }
      end

      it {
        is_expected.to compile.and_raise_error(%r{authorization_id or authentication_id or both})
      }
    end

    context "on #{os} without password and password_base64" do
      let(:params) do
        { authorization_id: 'authuser' }
      end

      it {
        is_expected.to compile.and_raise_error(%r{Either password or password_base64 must be set})
      }
    end

    context 'on #{os} with password and password_base64' do
      let(:params) do
        {
          password:         'secret',
          password_base64:  'secret',
          authorization_id: 'authuser',
        }
      end

      it {
        is_expected.to compile.and_raise_error(%r{Only one of password and password_base64 can be set})
      }
    end
  end
end
