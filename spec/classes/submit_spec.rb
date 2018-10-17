require 'spec_helper'

describe 'sendmail::submit' do
  let(:pre_condition) { 'include sendmail::service' }

  on_supported_os.each do |os, facts|
    context "on #{os} with default parameters" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'Debian'
        it {
          is_expected.to contain_class('sendmail::submit')
          is_expected.to contain_file('/etc/mail/submit.mc')
            .with_ensure('file')
            .with_owner('root')
            .with_group('smmsp')
            .with_mode('0644')
            .without_content(%r{^FEATURE\(`use_ct_file'\)dnl$})
            .with_content(%r{^OSTYPE\(`debian'\)dnl$})
            .with_content(%r{^FEATURE\(`msp', `\[127.0.0.1\]', `MSA'\)dnl$})

          is_expected.not_to contain_file('/etc/mail/foo.example.com.submit.mc')
        }
      when 'RedHat'
        it {
          is_expected.to contain_class('sendmail::submit')
          is_expected.to contain_file('/etc/mail/submit.mc')
            .with_ensure('file')
            .with_owner('root')
            .with_group('root')
            .with_mode('0644')
            .without_content(%r{^FEATURE\(`use_ct_file'\)dnl$})
            .without_content(%r{^OSTYPE})
            .with_content(%r{^FEATURE\(`msp', `\[127.0.0.1\]', `MSA'\)dnl$})

          is_expected.not_to contain_file('/etc/mail/foo.example.com.submit.mc')
        }
      when 'FreeBSD'
        it {
          is_expected.to contain_class('sendmail::submit')
          is_expected.to contain_file('/etc/mail/foo.submit.mc')
            .with_ensure('file')
            .with_owner('root')
            .with_group('wheel')
            .with_mode('0644')
            .without_content(%r{^FEATURE\(`use_ct_file'\)dnl$})
            .with_content(%r{^OSTYPE\(`freebsd6'\)dnl$})
            .with_content(%r{^FEATURE\(`msp', `\[127.0.0.1\]', `MSA'\)dnl$})

          is_expected.to contain_file('/etc/mail/foo.example.com.submit.mc')
            .with_ensure('link')
            .with_target('foo.submit.mc')
        }
      end
    end

    context "on #{os} with msp_host => localhost" do
      let(:facts) { facts }
      let(:params) do
        { msp_host: 'localhost' }
      end

      file = case facts[:osfamily]
             when 'FreeBSD' then '/etc/mail/foo.submit.mc'
             else '/etc/mail/submit.mc'
             end

      it {
        is_expected.to contain_file(file)
          .with_content(%r{^FEATURE\(`msp', `localhost', `MSA'\)dnl$})
      }
    end

    context "on #{os} with msp_port => 25" do
      let(:facts) { facts }
      let(:params) do
        { msp_port: '25' }
      end

      file = case facts[:osfamily]
             when 'FreeBSD' then '/etc/mail/foo.submit.mc'
             else '/etc/mail/submit.mc'
             end

      it {
        is_expected.to contain_file(file)
          .with_content(%r{^FEATURE\(`msp', `\[127.0.0.1\]', `25'\)dnl$})
      }
    end

    context "on #{os} with msp_port => MSA" do
      let(:facts) { facts }
      let(:params) do
        { msp_port: 'MSA' }
      end

      file = case facts[:osfamily]
             when 'FreeBSD' then '/etc/mail/foo.submit.mc'
             else '/etc/mail/submit.mc'
             end

      it {
        is_expected.to contain_file(file)
          .with_content(%r{^FEATURE\(`msp', `\[127.0.0.1\]', `MSA'\)dnl$})
      }
    end

    context "on #{os} with masquerade_as => example.org" do
      let(:facts) { facts }
      let(:params) do
        { masquerade_as: 'example.org' }
      end

      file = case facts[:osfamily]
             when 'FreeBSD' then '/etc/mail/foo.submit.mc'
             else '/etc/mail/submit.mc'
             end

      it {
        is_expected.to contain_file(file)
          .with_content(%r{^MASQUERADE_AS\(`example.org'\)dnl$})
          .with_content(%r{^FEATURE\(`masquerade_envelope'\)dnl$})
      }
    end

    context "on #{os} with enable_msp_trusted_users => true" do
      let(:facts) { facts }
      let(:params) do
        { enable_msp_trusted_users: true }
      end

      file = case facts[:osfamily]
             when 'FreeBSD' then '/etc/mail/foo.submit.mc'
             else '/etc/mail/submit.mc'
             end

      it {
        is_expected.to contain_file(file)
          .with_content(%r{^FEATURE\(`use_ct_file'\)dnl$})
      }
    end
  end
end
