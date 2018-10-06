require 'spec_helper'

describe 'sendmail::genericstable::entry' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    let(:title) { 'user@example.com' }
    let(:pre_condition) { 'include sendmail::service' }

    context "on #{os} with value" do
      let(:params) do
        { value: 'user@example.org' }
      end

      it {
        is_expected.to contain_class('sendmail::params')
        is_expected.to contain_class('sendmail::makeall')
        is_expected.to contain_class('sendmail::genericstable::file')
        is_expected.to contain_augeas('/etc/mail/genericstable-user@example.com') \
          .that_requires('Class[sendmail::genericstable::file]') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} without value" do
      let(:params) do
        { ensure: 'present' }
      end

      it {
        is_expected.to compile.and_raise_error(%r{value must be set when creating})
      }
    end
  end
end
