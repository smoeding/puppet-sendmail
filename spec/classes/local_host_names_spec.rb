require 'spec_helper'

describe 'sendmail::local_host_names' do
  let(:pre_condition) { 'include sendmail::service' }

  on_supported_os.each do |os, facts|
    context "on #{os} with default parameters" do
      let(:facts) { facts }

      it {
        case facts[:osfamily]
        when 'Debian'
          is_expected.to contain_file('/etc/mail/local-host-names')
            .with_ensure('file')
            .with_owner('root')
            .with_group('smmsp')
            .with_mode('0644')
            .with_content('')
        when 'RedHat'
          is_expected.to contain_file('/etc/mail/local-host-names')
            .with_ensure('file')
            .with_owner('root')
            .with_group('root')
            .with_mode('0644')
            .with_content('')
        when 'FreeBSD'
          is_expected.to contain_file('/etc/mail/local-host-names')
            .with_ensure('file')
            .with_owner('root')
            .with_group('wheel')
            .with_mode('0644')
            .with_content('')
        end
      }
    end

    context "on #{os} with empty parameter" do
      let(:facts) { facts }

      let(:params) do
        { local_host_names: [] }
      end

      it {
        is_expected.to contain_file('/etc/mail/local-host-names')
      }
    end

    context "on #{os} with single element array" do
      let(:facts) { facts }

      let(:params) do
        { local_host_names: ['foo'] }
      end

      it {
        is_expected.to contain_file('/etc/mail/local-host-names')
          .with_content("foo\n")
      }
    end

    context "on #{os} with multiple element array" do
      let(:facts) { facts }

      let(:params) do
        { local_host_names: ['foo', 'bar', 'baz'] }
      end

      it {
        is_expected.to contain_file('/etc/mail/local-host-names')
          .with_content("bar\nbaz\nfoo\n")
      }
    end
  end
end
