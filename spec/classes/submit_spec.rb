require 'spec_helper'

describe 'sendmail::submit' do

  it { should contain_class('sendmail::submit') }

  context 'On Debian with default parameters' do
    let(:facts) do
      { :operatingsystem => 'Debian', :osfamily => 'Debian', }
    end

    it {
      should contain_file('/etc/mail/submit.mc').with(
               'ensure' => 'file',
               'owner'  => 'root',
               'group'  => 'smmsp',
               'mode'   => '0644') \
              .without_content(/^FEATURE\(`use_ct_file'\)dnl$/) \
              .with_content(/^OSTYPE\(`debian'\)dnl$/) \
              .with_content(/^FEATURE\(`msp', `\[127.0.0.1\]', `MSA'\)dnl$/)
    }
  end

  context 'On RedHat with default parameters' do
    let(:facts) do
      { :operatingsystem => 'RedHat', :osfamily => 'RedHat', }
    end

    it {
      should contain_file('/etc/mail/submit.mc').with(
               'ensure' => 'file',
               'owner'  => 'root',
               'group'  => 'root',
               'mode'   => '0644') \
              .without_content(/^FEATURE\(`use_ct_file'\)dnl$/) \
              .without_content(/^OSTYPE/) \
              .with_content(/^FEATURE\(`msp', `\[127.0.0.1\]', `MSA'\)dnl$/)
    }
  end

  context 'with msp_host => localhost' do
    let(:params) do
      { :msp_host => 'localhost' }
    end

    it {
      should contain_file('/etc/mail/submit.mc') \
              .with_content(/^FEATURE\(`msp', `localhost', `MSA'\)dnl$/)
    }
  end

  context 'with msp_port => 25' do
    let(:params) do
      { :msp_port => '25' }
    end

    it {
      should contain_file('/etc/mail/submit.mc') \
              .with_content(/^FEATURE\(`msp', `\[127.0.0.1\]', `25'\)dnl$/)
    }
  end

  context 'with msp_port => foo' do
    let(:params) do
      { :msp_port => 'foo' }
    end

    it { expect { should compile }.to raise_error(/must be a numeric/) }
  end

  context 'masquerade_as => example.org' do
    let(:params) do
      { :masquerade_as => 'example.org' }
    end

    it {
      should contain_file('/etc/mail/submit.mc') \
              .with_content(/^MASQUERADE_AS\(`example.org'\)dnl$/) \
              .with_content(/^FEATURE\(`masquerade_envelope'\)dnl$/)

    }
  end

  context 'with enable_msp_trusted_users => true' do
    let(:params) do
      { :enable_msp_trusted_users => true }
    end

    it {
      should contain_file('/etc/mail/submit.mc') \
              .with_content(/^FEATURE\(`use_ct_file'\)dnl$/)
    }
  end
end
