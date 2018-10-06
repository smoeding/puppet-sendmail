require 'spec_helper'

describe 'sendmail::aliases::entry' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    let(:title) { 'fred' }

    context 'on #{os} with recipient' do
      let(:params) do
        { recipient: 'fred@example.org' }
      end

      it {
        is_expected.to contain_class('sendmail::params')
        is_expected.to contain_class('sendmail::aliases::file')
        is_expected.to contain_class('sendmail::aliases::newaliases')
        is_expected.to contain_mailalias('fred') \
          .that_requires('Class[sendmail::aliases::file]') \
          .that_notifies('Class[sendmail::aliases::newaliases]')

        is_expected.to contain_mailalias('fred') \
          .with_ensure('present') \
          .with_recipient('fred@example.org')
      }
    end

    context "on #{os} with ensure => absent" do
      let(:params) do
        { recipient: 'fred@example.org', ensure: 'absent' }
      end

      it {
        is_expected.to contain_mailalias('fred').with_ensure('absent')
      }
    end

    context "on #{os} without recipient" do
      let(:params) do
        { ensure: 'present' }
      end

      it {
        is_expected.to compile.and_raise_error(%r{recipient must be set when creating})
      }
    end
  end
end
