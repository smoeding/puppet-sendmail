require 'spec_helper'

describe 'sendmail::mc' do
  let(:pre_condition) { 'include sendmail::service' }

  on_supported_os.each do |os, facts|
    context "on #{os} with default parameters" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'Debian'
        it {
          is_expected.to contain_class('sendmail::mc')
          is_expected.to contain_concat('sendmail.mc')
            .with_ensure('present')
            .with_path('/etc/mail/sendmail.mc')
            .with_owner('root')
            .with_group('smmsp')
            .with_mode('0644')
            .that_notifies('Class[sendmail::makeall]')

          is_expected.to contain_concat__fragment('sendmail_mc-header')
            .with_content(%r{^include\(`/usr/share/sendmail/cf/m4/cf\.m4'\)})
            .with_content(%r{^# Host: foo\.example\.com$})
            .with_content(%r{^define\(`_USE_ETC_MAIL_'\)dnl})
            .with_order('00')

          is_expected.to contain_sendmail__mc__ostype('debian')
          is_expected.to contain_sendmail__mc__domain('debian-mta')

          is_expected.not_to contain_file('/etc/mail/foo.mc')
        }
      when 'RedHat'
        it {
          is_expected.to contain_class('sendmail::mc')
          is_expected.to contain_concat('sendmail.mc')
            .with_ensure('present')
            .with_path('/etc/mail/sendmail.mc')
            .with_owner('root')
            .with_group('root')
            .with_mode('0644')
            .that_notifies('Class[sendmail::makeall]')

          is_expected.to contain_concat__fragment('sendmail_mc-header')
            .with_content(%r{^include\(`/usr/share/sendmail-cf/m4/cf\.m4'\)})
            .with_content(%r{^# Host: foo\.example\.com$})
            .with_content(%r{^define\(`_USE_ETC_MAIL_'\)dnl})
            .with_order('00')

          is_expected.to contain_sendmail__mc__ostype('linux')

          is_expected.not_to contain_file('/etc/mail/foo.mc')
        }
      when 'FreeBSD'
        it {
          is_expected.to contain_class('sendmail::mc')
          is_expected.to contain_concat('sendmail.mc')
            .with_ensure('present')
            .with_path('/etc/mail/foo.mc')
            .with_owner('root')
            .with_group('wheel')
            .with_mode('0644')
            .that_notifies('Class[sendmail::makeall]')

          is_expected.to contain_concat__fragment('sendmail_mc-header')
            .without_content(%r{^include})
            .with_content(%r{^# Host: foo\.example\.com$})
            .with_content(%r{^define\(`_USE_ETC_MAIL_'\)dnl})
            .with_order('00')

          is_expected.to contain_sendmail__mc__ostype('freebsd6')

          is_expected.to contain_file('/etc/mail/foo.example.com.mc')
            .with_ensure('link')
            .with_target('foo.mc')
        }
      end

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-header')
          .with_target('sendmail.mc')
          .with_order('00')

        is_expected.not_to contain_sendmail__mc__define('SMART_HOST')
        is_expected.not_to contain_sendmail__mc__define('confCF_VERSION')
        is_expected.not_to contain_sendmail__mc__define('confLOG_LEVEL')
        is_expected.not_to contain_sendmail__mc__define('confDOMAIN_NAME')
        is_expected.not_to contain_sendmail__mc__define('confMAX_MESSAGE_SIZE')
        is_expected.not_to contain_sendmail__mc__define('confDONT_PROBE_INTERFACES')
        is_expected.not_to contain_sendmail__mc__trust_auth_mech('trust_auth_mech')

        is_expected.to contain_sendmail__mc__daemon_options('MTA-v4')
          .with_family('inet')

        is_expected.to contain_sendmail__mc__daemon_options('MTA-v6')
          .with_family('inet6')

        is_expected.to contain_sendmail__mc__mailer('local')
        is_expected.to contain_sendmail__mc__mailer('smtp')
      }
    end

    context "on #{os} with ostype => debian" do
      let(:facts) { facts }
      let(:params) do
        { ostype: 'debian' }
      end

      it {
        is_expected.to contain_sendmail__mc__ostype('debian')
      }
    end

    context "on #{os} with ostype => linux" do
      let(:facts) { facts }
      let(:params) do
        { ostype: 'linux' }
      end

      it {
        is_expected.to contain_sendmail__mc__ostype('linux')
      }
    end

    context "on #{os} with ostype => freebsd6" do
      let(:facts) { facts }
      let(:params) do
        { ostype: 'freebsd6' }
      end

      it {
        is_expected.to contain_sendmail__mc__ostype('freebsd6')
      }
    end

    context "on #{os} with sendmail_mc_domain => foobar" do
      let(:facts) { facts }
      let(:params) do
        { sendmail_mc_domain: 'foobar' }
      end

      it {
        is_expected.to contain_sendmail__mc__domain('foobar')
      }
    end

    context "on #{os} with smart_host => relay" do
      let(:facts) { facts }
      let(:params) do
        { smart_host: 'relay' }
      end

      it {
        is_expected.to contain_sendmail__mc__define('SMART_HOST')
          .with_expansion('relay')
      }
    end

    context "on #{os} with log_level => 7" do
      let(:facts) { facts }
      let(:params) do
        { log_level: 7 }
      end

      it {
        is_expected.to contain_sendmail__mc__define('confLOG_LEVEL')
          .with_expansion(7)
      }
    end

    context "on #{os} with log_level => '7'" do
      let(:facts) { facts }
      let(:params) do
        { log_level: '7' }
      end

      it {
        is_expected.to contain_sendmail__mc__define('confLOG_LEVEL')
          .with_expansion('7')
      }
    end

    context "on #{os} with domain_name => smtp.example.com" do
      let(:facts) { facts }
      let(:params) do
        { domain_name: 'smtp.example.com' }
      end

      it {
        is_expected.to contain_sendmail__mc__define('confDOMAIN_NAME')
          .with_expansion('smtp.example.com')
      }
    end

    context "on #{os} with max_message_size => 42" do
      let(:facts) { facts }
      let(:params) do
        { max_message_size: '42' }
      end

      it {
        is_expected.to contain_sendmail__mc__define('confMAX_MESSAGE_SIZE')
          .with_expansion('42')
      }
    end

    context "on #{os} with max_message_size => 1kB" do
      let(:facts) { facts }
      let(:params) do
        { max_message_size: '1kB' }
      end

      it {
        is_expected.to contain_sendmail__mc__define('confMAX_MESSAGE_SIZE')
          .with_expansion('1024')
      }
    end

    context "on #{os} with max_message_size => 1MB" do
      let(:facts) { facts }
      let(:params) do
        { max_message_size: '1MB' }
      end

      it {
        is_expected.to contain_sendmail__mc__define('confMAX_MESSAGE_SIZE')
          .with_expansion('1048576')
      }
    end

    context "on #{os} with enable_ipv4_daemon => true" do
      let(:facts) { facts }
      let(:params) do
        { enable_ipv4_daemon: true }
      end

      it {
        is_expected.to contain_sendmail__mc__daemon_options('MTA-v4')
      }
    end

    context "on #{os} with enable_ipv4_daemon => false" do
      let(:facts) { facts }
      let(:params) do
        { enable_ipv4_daemon: false }
      end

      it {
        is_expected.not_to contain_sendmail__mc__daemon_options('MTA-v4')
      }
    end

    context "on #{os} with enable_ipv6_daemon => true" do
      let(:facts) { facts }
      let(:params) do
        { enable_ipv6_daemon: true }
      end

      it {
        is_expected.to contain_sendmail__mc__daemon_options('MTA-v6')
      }
    end

    context "on #{os} with enable_ipv6_daemon => false" do
      let(:facts) { facts }
      let(:params) do
        { enable_ipv6_daemon: false }
      end

      it {
        is_expected.not_to contain_sendmail__mc__daemon_options('MTA-v6')
      }
    end

    context "on #{os} with mailers => [ 'foobar' ]" do
      let(:facts) { facts }
      let(:params) do
        { mailers: ['foobar'] }
      end

      it {
        is_expected.to contain_sendmail__mc__mailer('foobar')
        is_expected.not_to contain_sendmail__mc__mailer('local')
        is_expected.not_to contain_sendmail__mc__mailer('smtp')
      }
    end

    context "on #{os} with trust_auth_mech => PLAIN" do
      let(:facts) { facts }
      let(:params) do
        { trust_auth_mech: 'PLAIN' }
      end

      it {
        is_expected.to contain_sendmail__mc__trust_auth_mech('trust_auth_mech')
          .with_trust_auth_mech('PLAIN')
      }
    end

    context "on #{os} with trust_auth_mech => [ PLAIN, LOGIN ]" do
      let(:facts) { facts }
      let(:params) do
        { trust_auth_mech: ['PLAIN', 'LOGIN'] }
      end

      it {
        is_expected.to contain_sendmail__mc__trust_auth_mech('trust_auth_mech')
          .with_trust_auth_mech(['PLAIN', 'LOGIN'])
      }
    end

    context "on #{os} with cf_version => 1.2-3" do
      let(:facts) { facts }
      let(:params) do
        { cf_version: '1.2-3' }
      end

      it {
        is_expected.to contain_sendmail__mc__define('confCF_VERSION')
          .with_expansion('1.2-3')
      }
    end

    context "on #{os} with version_id => foo" do
      let(:facts) { facts }
      let(:params) do
        { version_id: 'foo' }
      end

      it {
        is_expected.to contain_sendmail__mc__versionid('foo')
      }
    end
  end
end
