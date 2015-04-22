require 'spec_helper'

describe 'sendmail::submit' do

  context 'On Debian with default parameters' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    it {
      should contain_file('/etc/mail/submit.mc').with(
               'ensure' => 'file',
               'owner'  => 'root',
               'group'  => 'smmsp',
               'mode'   => '0644') \
              .that_notifies('Class[sendmail::makeall]') \
              .that_notifies('Class[sendmail::service]') \
              .with_content(/^FEATURE\(`msp', `\[127.0.0.1\]', `MSA'\)dnl$/)

    }
  end

  context 'On Debian with msp_host => relay.example.org' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :msp_host => 'relay.example.org' }
    end

    it {
      should contain_file('/etc/mail/submit.mc') \
              .with_content(/^FEATURE\(`msp', `relay.example.org', `MSA'\)dnl$/)
    }
  end

  context 'On Debian with msp_port => 25' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :msp_port => '25' }
    end

    it {
      should contain_file('/etc/mail/submit.mc') \
              .with_content(/^FEATURE\(`msp', `\[127.0.0.1\]', `25'\)dnl$/)
    }
  end

  context 'On Debian with masquerade_as => example.org' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :masquerade_as => 'example.org' }
    end

    it {
      should contain_file('/etc/mail/submit.mc') \
              .with_content(/^MASQUERADE_AS\(`example.org'\)dnl$/) \
              .with_content(/^FEATURE\(`masquerade_envelope'\)dnl$/)

    }
  end
end
