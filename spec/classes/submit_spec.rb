require 'spec_helper'

describe 'sendmail::submit' do

  it { should contain_class('sendmail::submit') }

  on_supported_os.each do |os, facts|
    context "on #{os} with default parameters" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'Debian'
        it {
          should contain_file('/etc/mail/submit.mc').with(
                   'ensure' => 'file',
                   'owner'  => 'root',
                   'group'  => 'smmsp',
                   'mode'   => '0644') \
                  .without_content(/^FEATURE\(`use_ct_file'\)dnl$/) \
                  .with_content(/^OSTYPE\(`debian'\)dnl$/) \
                  .with_content(/^FEATURE\(`msp', `\[127.0.0.1\]', `MSA'\)dnl$/)

          should_not contain_file('/etc/mail/foo.example.com.submit.mc')
        }
      when 'RedHat'
        it {
          should contain_file('/etc/mail/submit.mc').with(
                   'ensure' => 'file',
                   'owner'  => 'root',
                   'group'  => 'root',
                   'mode'   => '0644') \
                  .without_content(/^FEATURE\(`use_ct_file'\)dnl$/) \
                  .without_content(/^OSTYPE/) \
                  .with_content(/^FEATURE\(`msp', `\[127.0.0.1\]', `MSA'\)dnl$/)

          should_not contain_file('/etc/mail/foo.example.com.submit.mc')
        }
      when 'FreeBSD'
        it {
          should contain_file('/etc/mail/foo.submit.mc').with(
                   'ensure' => 'file',
                   'owner'  => 'root',
                   'group'  => 'wheel',
                   'mode'   => '0644') \
                  .without_content(/^FEATURE\(`use_ct_file'\)dnl$/) \
                  .with_content(/^OSTYPE\(`freebsd6'\)dnl$/) \
                  .with_content(/^FEATURE\(`msp', `\[127.0.0.1\]', `MSA'\)dnl$/)

          should contain_file('/etc/mail/foo.example.com.submit.mc') \
                  .with_ensure('link') \
                  .with_target('foo.submit.mc')
        }
      end
    end
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
