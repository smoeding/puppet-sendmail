require 'spec_helper'

describe 'sendmail::mc' do

  context 'with no arguments' do
    it {
      should contain_concat('sendmail.mc').with(
               'ensure' => 'present',
               'path'   => '/tmp/sendmail.mc',
               'owner'  => 'root',
               'group'  => 'smmsp',
               'mode'   => '0644',
             )

      should contain_concat__fragment('sendmail_mc-header').with(
               'target'  => 'sendmail.mc',
               'order'   => '00'
             ).that_notifies('Class[sendmail::makeall]')

      should contain_sendmail__mc__ostype('debian')
      should contain_sendmail__mc__domain('debian-mta')

      should_not contain_sendmail__mc__define('SMART_HOST')
      should_not contain_sendmail__mc__define('confLOG_LEVEL')
      should_not contain_sendmail__mc__define('confMAX_MESSAGE_SIZE')
      should_not contain_sendmail__mc__define('confDONT_PROBE_INTERFACES')

      should contain_sendmail__mc__daemon_options('MTA-v4').with_family('inet')
      should contain_sendmail__mc__daemon_options('MTA-v6').with_family('inet6')

      should contain_sendmail__mc__mailer('local')
      should contain_sendmail__mc__mailer('smtp')
    }
  end

  context 'with ostype => foonix' do
    let(:params) do
      { :ostype => 'foonix' }
    end

    it {
      should contain_sendmail__mc__ostype('foonix')
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

  context 'with max_message_size => 42' do
    let(:params) do
      { :max_message_size => 42 }
    end

    it {
      should contain_sendmail__mc__define('confMAX_MESSAGE_SIZE').with(
               'expansion' => '42',
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
end
