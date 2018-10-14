require 'spec_helper'

describe 'sendmail::authinfo::file' do
  let(:pre_condition) { 'include sendmail::service' }

  on_supported_os.each do |os, facts|
    context "on #{os} with default parameters" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'Debian'
        it {
          is_expected.to contain_class('sendmail::authinfo::file')
          is_expected.to contain_file('/etc/mail/authinfo')
            .with_ensure('file')
            .with_owner('root')
            .with_group('smmsp')
            .with_mode('0600')
            .with_content(nil)
            .with_source(nil)
            .that_notifies('Class[sendmail::makeall]')
        }
      when 'RedHat'
        it {
          is_expected.to contain_class('sendmail::authinfo::file')
          is_expected.to contain_file('/etc/mail/authinfo')
            .with_ensure('file')
            .with_owner('root')
            .with_group('root')
            .with_mode('0600')
            .with_content(nil)
            .with_source(nil)
            .that_notifies('Class[sendmail::makeall]')
        }
      when 'FreeBSD'
        it {
          is_expected.to contain_class('sendmail::authinfo::file')
          is_expected.to contain_file('/etc/mail/authinfo')
            .with_ensure('file')
            .with_owner('root')
            .with_group('wheel')
            .with_mode('0600')
            .with_content(nil)
            .with_source(nil)
            .that_notifies('Class[sendmail::makeall]')
        }
      end
    end

    context "on #{os} with content => foo" do
      let(:facts) { facts }
      let(:params) do
        { content: 'foo' }
      end

      it {
        is_expected.to contain_file('/etc/mail/authinfo')
          .with_ensure('file')
          .with_content('foo')
          .with_source(nil)
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with source => foo" do
      let(:facts) { facts }
      let(:params) do
        { source: 'foo' }
      end

      it {
        is_expected.to contain_file('/etc/mail/authinfo')
          .with_ensure('file')
          .with_content(nil)
          .with_source('foo')
          .that_notifies('Class[sendmail::makeall]')
      }
    end
  end
end
