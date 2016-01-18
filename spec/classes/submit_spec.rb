require 'spec_helper'

describe 'sendmail::submit' do

  it { should contain_class('sendmail::submit') }

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
              .without_content(/^FEATURE\(`use_ct_file'\)dnl$/) \
              .with_content(/^FEATURE\(`msp', `\[127.0.0.1\]', `MSA'\)dnl$/)
    }
  end

  context 'On Debian with msp_host => localhost' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :msp_host => 'localhost' }
    end

    it {
      should contain_file('/etc/mail/submit.mc') \
              .with_content(/^FEATURE\(`msp', `localhost', `MSA'\)dnl$/)
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

  context 'On Debian with msp_port => foo' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :msp_port => 'foo' }
    end

    it { expect { should compile }.to raise_error(/must be a numeric/) }
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

  context 'On Debian with enable_msp_trusted_users => true' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :enable_msp_trusted_users => true }
    end

    it {
      should contain_file('/etc/mail/submit.mc').with(
               'ensure' => 'file',
               'owner'  => 'root',
               'group'  => 'smmsp',
               'mode'   => '0644') \
              .with_content(/^FEATURE\(`use_ct_file'\)dnl$/)
    }
  end
end
