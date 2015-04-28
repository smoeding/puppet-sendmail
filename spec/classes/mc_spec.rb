require 'spec_helper'

describe 'sendmail::mc' do

    # :id and :osfamily facts are needed for concat module
  let(:facts) do
    {
      :id              => 'stm',
      :osfamily        => 'Debian',
      :operatingsystem => 'Debian',
      :concat_basedir  => '/tmp',
    }
  end

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

      should contain_sendmail__mc__domain('generic')

      should_not contain_sendmail__mc__define('SMART_HOST')

      should contain_sendmail__mc__daemon_options('IPv4').with_family('inet')
      should contain_sendmail__mc__daemon_options('IPv6').with_family('inet6')

      should_not contain_sendmail__mc__define('SMART_HOST')

      should contain_sendmail__mc__mailer('local')
      should contain_sendmail__mc__mailer('smtp')
    }
  end

  context 'with smart_host => relay' do
    let(:params) do
      { 'smart_host' => 'relay' }
    end

    it {
      should contain_sendmail__mc__define('SMART_HOST').with(
               'expansion' => 'relay',
             )
    }
  end

  context 'with enable_ipv4_daemon => false' do
    let(:params) do
      { 'enable_ipv4_daemon' => false }
    end

    it {
      should_not contain_sendmail__mc__daemon_options('IPv4')
      should contain_sendmail__mc__daemon_options('IPv6')
    }
  end

  context 'with enable_ipv6_daemon => false' do
    let(:params) do
      { 'enable_ipv6_daemon' => false }
    end

    it {
      should contain_sendmail__mc__daemon_options('IPv4')
      should_not contain_sendmail__mc__daemon_options('IPv6')
    }
  end
end
