require 'spec_helper'

describe 'sendmail::relay_domains' do
  let(:pre_condition) { 'include sendmail::service' }

  on_supported_os.each do |os, facts|
    context "on #{os} with default parameters" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'Debian'
        it {
          is_expected.to contain_class('sendmail::relay_domains')
          is_expected.to contain_file('/etc/mail/relay-domains') \
            .with_ensure('file') \
            .with_owner('root') \
            .with_group('smmsp') \
            .with_mode('0644') \
            .with_content('')
        }
      when 'RedHat'
        it {
          is_expected.to contain_class('sendmail::relay_domains')
          is_expected.to contain_file('/etc/mail/relay-domains') \
            .with_ensure('file') \
            .with_owner('root') \
            .with_group('root') \
            .with_mode('0644') \
            .with_content('')
        }
      when 'FreeBSD'
        it {
          is_expected.to contain_class('sendmail::relay_domains')
          is_expected.to contain_file('/etc/mail/relay-domains') \
            .with_ensure('file') \
            .with_owner('root') \
            .with_group('wheel') \
            .with_mode('0644') \
            .with_content('')
        }
      end
    end

    context "on #{os} with string parameter type" do
      let(:facts) { facts }
      let(:params) do
        { relay_domains: 'example.org' }
      end

      it { is_expected.to compile.and_raise_error(%r{is not an Array}) }
    end

    context "on #{os} with empty parameter" do
      let(:facts) { facts }
      let(:params) do
        { relay_domains: [] }
      end

      it {
        is_expected.to contain_file('/etc/mail/relay-domains')
      }
    end

    context "on #{os} with single element array" do
      let(:facts) { facts }
      let(:params) do
        { relay_domains: ['foo'] }
      end

      it {
        is_expected.to contain_file('/etc/mail/relay-domains') \
          .with_content("foo\n")
      }
    end

    context "on #{os} with multiple element array" do
      let(:facts) { facts }
      let(:params) do
        { relay_domains: ['foo', 'bar', 'baz'] }
      end

      it {
        is_expected.to contain_file('/etc/mail/relay-domains') \
          .with_content("bar\nbaz\nfoo\n")
      }
    end
  end
end
