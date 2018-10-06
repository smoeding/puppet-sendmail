require 'spec_helper'

describe 'sendmail::virtusertable::entry' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    let(:title) { 'info@example.com' }
    let(:pre_condition) { 'include sendmail::service' }

    context "on #{os} with value" do
      let(:params) do
        { value: 'fred' }
      end

      it {
        is_expected.to contain_class('sendmail::params')
        is_expected.to contain_class('sendmail::makeall')
        is_expected.to contain_class('sendmail::virtusertable::file')
        is_expected.to contain_augeas('/etc/mail/virtusertable-info@example.com') \
          .that_requires('Class[sendmail::virtusertable::file]') \
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
