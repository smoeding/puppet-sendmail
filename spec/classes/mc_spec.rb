require 'spec_helper'

describe 'sendmail::mc' do

  it { should contain_class('sendmail::mc') }

  on_supported_os.each do |os, facts|
    context "on #{os} with default parameters" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'Debian'
        it {
          should contain_concat('sendmail.mc').with(
                   'ensure' => 'present',
                   'path'   => '/etc/mail/sendmail.mc',
                   'owner'  => 'root',
                   'group'  => 'smmsp',
                   'mode'   => '0644',
                 )

          should contain_sendmail__mc__ostype('debian')
          should contain_sendmail__mc__domain('debian-mta')

          should_not contain_file('/etc/mail/foo.example.com.mc')
        }
      when 'RedHat'
        it {
          should contain_concat('sendmail.mc').with(
                   'ensure' => 'present',
                   'path'   => '/etc/mail/sendmail.mc',
                   'owner'  => 'root',
                   'group'  => 'root',
                   'mode'   => '0644',
                 )

          should contain_sendmail__mc__ostype('linux')

          should_not contain_file('/etc/mail/foo.example.com.mc')
        }
      when 'FreeBSD'
        it {
          should contain_concat('sendmail.mc').with(
                   'ensure' => 'present',
                   'path'   => '/etc/mail/foo.mc',
                   'owner'  => 'root',
                   'group'  => 'wheel',
                   'mode'   => '0644',
                 )

          should contain_sendmail__mc__ostype('freebsd6')

          should contain_file('/etc/mail/foo.example.com.mc') \
                  .with_ensure('link') \
                  .with_target('foo.mc')
        }
      end

      it {
        should contain_concat__fragment('sendmail_mc-header').with(
                 'target'  => 'sendmail.mc',
                 'order'   => '00'
               ).that_notifies('Class[sendmail::makeall]')

        should_not contain_sendmail__mc__define('SMART_HOST')
        should_not contain_sendmail__mc__define('confCF_VERSION')
        should_not contain_sendmail__mc__define('confLOG_LEVEL')
        should_not contain_sendmail__mc__define('confDOMAIN_NAME')
        should_not contain_sendmail__mc__define('confMAX_MESSAGE_SIZE')
        should_not contain_sendmail__mc__define('confDONT_PROBE_INTERFACES')
        should_not contain_sendmail__mc__trust_auth_mech('trust_auth_mech')

        should contain_sendmail__mc__daemon_options('MTA-v4').with(
                 'family' => 'inet'
               )

        should contain_sendmail__mc__daemon_options('MTA-v6').with(
                 'family' =>'inet6'
               )

        should contain_sendmail__mc__mailer('local')
        should contain_sendmail__mc__mailer('smtp')
      }
    end
  end

  context 'with ostype => debian' do
    let(:params) do
      { :ostype => 'debian' }
    end

    it {
      should contain_sendmail__mc__ostype('debian')
    }
  end

  context 'with ostype => linux' do
    let(:params) do
      { :ostype => 'linux' }
    end

    it {
      should contain_sendmail__mc__ostype('linux')
    }
  end

  context 'with ostype => freebsd6' do
    let(:params) do
      { :ostype => 'freebsd6' }
    end

    it {
      should contain_sendmail__mc__ostype('freebsd6')
    }
  end

  context 'with sendmail_mc_domain => foobar' do
    let(:params) do
      { :sendmail_mc_domain => 'foobar' }
    end

    it {
      should contain_sendmail__mc__domain('foobar')
    }
  end

  context 'with smart_host => relay' do
    let(:params) do
      { :smart_host => 'relay' }
    end

    it {
      should contain_sendmail__mc__define('SMART_HOST').with(
               'expansion' => 'relay',
             )
    }
  end

  context 'with log_level => 7' do
    let(:params) do
      { :log_level => '7' }
    end

    it {
      should contain_sendmail__mc__define('confLOG_LEVEL').with(
               'expansion' => '7',
             )
    }
  end

  context 'with log_level => foo' do
    let(:params) do
      { :log_level => 'foo' }
    end

    it { expect { should compile }.to raise_error(/must be numeric/) }
  end

  context 'with domain_name => smtp.example.com' do
    let(:params) do
      { :domain_name => 'smtp.example.com' }
    end

    it {
      should contain_sendmail__mc__define('confDOMAIN_NAME').with(
               'expansion' => 'smtp.example.com',
             )
    }
  end

  context 'with max_message_size => 42' do
    let(:params) do
      { :max_message_size => '42' }
    end

    it {
      should contain_sendmail__mc__define('confMAX_MESSAGE_SIZE').with(
               'expansion' => '42',
             )
    }
  end

  context 'with max_message_size => 1kB' do
    let(:params) do
      { :max_message_size => '1kB' }
    end

    it {
      should contain_sendmail__mc__define('confMAX_MESSAGE_SIZE').with(
               'expansion' => '1024',
             )
    }
  end

  context 'with max_message_size => 1MB' do
    let(:params) do
      { :max_message_size => '1MB' }
    end

    it {
      should contain_sendmail__mc__define('confMAX_MESSAGE_SIZE').with(
               'expansion' => '1048576',
             )
    }
  end

  context 'with max_message_size => foo' do
    let(:params) do
      { :max_message_size => 'foo' }
    end

    it { expect { should compile }.to raise_error(/must be numeric/) }
  end

  context 'with dont_probe_interfaces => foo' do
    let(:params) do
      { :dont_probe_interfaces => 'foo' }
    end

    it {
      should contain_sendmail__mc__define('confDONT_PROBE_INTERFACES').with(
               'expansion' => 'foo',
             )
    }
  end

  context 'with enable_ipv4_daemon => true' do
    let(:params) do
      { :enable_ipv4_daemon => true }
    end

    it {
      should contain_sendmail__mc__daemon_options('MTA-v4')
    }
  end

  context 'with enable_ipv4_daemon => false' do
    let(:params) do
      { :enable_ipv4_daemon => false }
    end

    it {
      should_not contain_sendmail__mc__daemon_options('MTA-v4')
    }
  end

  context 'with enable_ipv6_daemon => true' do
    let(:params) do
      { :enable_ipv6_daemon => true }
    end

    it {
      should contain_sendmail__mc__daemon_options('MTA-v6')
    }
  end

  context 'with enable_ipv6_daemon => false' do
    let(:params) do
      { :enable_ipv6_daemon => false }
    end

    it {
      should_not contain_sendmail__mc__daemon_options('MTA-v6')
    }
  end

  context "with mailers => [ 'foobar' ]" do
    let(:params) do
      { :mailers => [ 'foobar' ] }
    end

    it {
      should contain_sendmail__mc__mailer('foobar')
      should_not contain_sendmail__mc__mailer('local')
      should_not contain_sendmail__mc__mailer('smtp')
    }
  end

  context 'with trust_auth_mech => PLAIN' do
    let(:params) do
      { :trust_auth_mech => 'PLAIN' }
    end

    it {
      should contain_sendmail__mc__trust_auth_mech('trust_auth_mech').with(
               'trust_auth_mech' => 'PLAIN'
             )
    }
  end

  context 'with trust_auth_mech => [ PLAIN, LOGIN ]' do
    let(:params) do
      { :trust_auth_mech => [ 'PLAIN', 'LOGIN' ] }
    end

    it {
      should contain_sendmail__mc__trust_auth_mech('trust_auth_mech').with(
               'trust_auth_mech' => [ 'PLAIN', 'LOGIN' ]
             )
    }
  end

  context 'with cf_version => 1.2-3' do
    let(:params) do
      { :cf_version => '1.2-3' }
    end

    it {
      should contain_sendmail__mc__define('confCF_VERSION').with(
               'expansion' => '1.2-3',
             )
    }
  end

  context 'with version_id => foo' do
    let(:params) do
      { :version_id => 'foo' }
    end

    it {
      should contain_sendmail__mc__versionid('foo')
    }
  end
end
