require 'spec_helper'

describe 'sendmail' do
  on_supported_os.each do |os, facts|
    context "on #{os} with defaults" do
      let(:facts) { facts }

      it {
        is_expected.to contain_class('sendmail')
        is_expected.to contain_class('sendmail::params')

        is_expected.to contain_class('sendmail::package')

        is_expected.to contain_class('sendmail::local_host_names')
        is_expected.to contain_class('sendmail::relay_domains')
        is_expected.to contain_class('sendmail::trusted_users')
        is_expected.to contain_class('sendmail::mc')
          .that_requires('Class[sendmail::package]')
          .that_notifies('Class[sendmail::service]')

        is_expected.to contain_class('sendmail::submit').with(
          'msp_host'                 => '[127.0.0.1]',
          'msp_port'                 => 'MSA',
          'enable_msp_trusted_users' => false,
        )

        is_expected.to contain_class('sendmail::service')

        is_expected.not_to contain_class('sendmail::mc::starttls')
      }
    end

    context "on #{os} with domain_name => smtp.example.com" do
      let(:facts) { facts }

      let(:params) do
        { domain_name: 'smtp.example.com' }
      end

      it {
        is_expected.to contain_class('sendmail::mc')
          .with_domain_name('smtp.example.com')
      }
    end

    context "on #{os} with max_message_size => 42" do
      let(:facts) { facts }

      let(:params) do
        { max_message_size: '42' }
      end

      it {
        is_expected.to contain_class('sendmail::mc')
          .with_max_message_size('42')
      }
    end

    context "on #{os} with local_host_names => www.example.net" do
      let(:facts) { facts }

      let(:params) do
        { local_host_names: ['www.example.net'] }
      end

      it {
        is_expected.to contain_class('sendmail::local_host_names')
          .with_local_host_names(['www.example.net'])
      }
    end

    context "on #{os} with relay_domains => example.net" do
      let(:facts) { facts }

      let(:params) do
        { relay_domains: ['example.net'] }
      end

      it {
        is_expected.to contain_class('sendmail::relay_domains')
          .with_relay_domains(['example.net'])
      }
    end

    context "on #{os} with trusted_users => fred" do
      let(:facts) { facts }

      let(:params) do
        { trusted_users: ['fred'] }
      end

      it {
        is_expected.to contain_class('sendmail::trusted_users')
          .with_trusted_users(['fred'])
      }
    end

    context "on #{os} with trust_auth_mech => PLAIN" do
      let(:facts) { facts }

      let(:params) do
        { trust_auth_mech: 'PLAIN' }
      end

      it {
        is_expected.to contain_class('sendmail::mc')
          .with_trust_auth_mech('PLAIN')
      }
    end

    context "on #{os} with trust_auth_mech => [ PLAIN, LOGIN ]" do
      let(:facts) { facts }

      let(:params) do
        { trust_auth_mech: ['PLAIN', 'LOGIN'] }
      end

      it {
        is_expected.to contain_class('sendmail::mc')
          .with_trust_auth_mech(['PLAIN', 'LOGIN'])
      }
    end

    context "on #{os} with cf_version => 1.2-3" do
      let(:facts) { facts }

      let(:params) do
        { cf_version: '1.2-3' }
      end

      it {
        is_expected.to contain_class('sendmail::mc')
          .with_cf_version('1.2-3')
      }
    end

    context "on #{os} with version_id => foo" do
      let(:facts) { facts }

      let(:params) do
        { version_id: 'foo' }
      end

      it {
        is_expected.to contain_class('sendmail::mc')
          .with_version_id('foo')
      }
    end

    context "on #{os} with msp_host => localhost" do
      let(:facts) { facts }

      let(:params) do
        { msp_host: 'localhost' }
      end

      it {
        is_expected.to contain_class('sendmail::submit')
          .with_msp_host('localhost')
      }
    end

    context "on #{os} with msp_port => 25" do
      let(:facts) { facts }

      let(:params) do
        { msp_port: '25' }
      end

      it {
        is_expected.to contain_class('sendmail::submit')
          .with_msp_port('25')
      }
    end

    context "on #{os} with enable_msp_trusted_users => true" do
      let(:facts) { facts }

      let(:params) do
        { enable_msp_trusted_users: true }
      end

      it {
        is_expected.to contain_class('sendmail::submit')
          .with_enable_msp_trusted_users(true)
      }
    end

    context "on #{os} with manage_sendmail_mc => true" do
      let(:facts) { facts }

      let(:params) do
        { manage_sendmail_mc: true }
      end

      it {
        is_expected.to contain_class('sendmail::mc')
          .that_requires('Class[sendmail::package]')
          .that_notifies('Class[sendmail::service]')
      }
    end

    context "on #{os} with manage_sendmail_mc => false" do
      let(:facts) { facts }

      let(:params) do
        { manage_sendmail_mc: false }
      end

      it {
        is_expected.not_to contain_class('sendmail::mc')
        is_expected.not_to contain_class('sendmail::mc::starttls')
      }
    end

    context "on #{os} with manage_submit_mc => true" do
      let(:facts) { facts }

      let(:params) do
        { manage_submit_mc: true }
      end

      it {
        is_expected.to contain_class('sendmail::submit')
          .that_requires('Class[sendmail::package]')
          .that_notifies('Class[sendmail::service]')
      }
    end

    context "on #{os} with manage_submit_mc => false" do
      let(:facts) { facts }

      let(:params) do
        { manage_submit_mc: false }
      end

      it {
        is_expected.not_to contain_class('sendmail::submit')
      }
    end

    context "on #{os} with cipher_list defined" do
      let(:facts) { facts }

      let(:params) do
        { manage_sendmail_mc: true, cipher_list: 'foo' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::starttls')
          .with_cipher_list('foo')
      }
    end

    context "on #{os} with features defining a simple feature" do
      let(:facts) { facts }

      let(:params) do
        { features: { 'no_default_msa' => {} } }
      end

      it {
        is_expected.to contain_sendmail__mc__feature('no_default_msa')
      }
    end

    context "on #{os} with features defining a complex feature" do
      let(:facts) { facts }

      let(:params) do
        { features: { 'no_default_msa' => { 'args' => 'foo' } } }
      end

      it {
        is_expected.to contain_sendmail__mc__feature('no_default_msa')
          .with_args('foo')
      }
    end

    context "on #{os} with features defining multiple features" do
      let(:facts) { facts }

      let(:params) do
        { features: { 'conncontrol' => {}, 'ratecontrol' => {} } }
      end

      it {
        is_expected.to contain_sendmail__mc__feature('conncontrol')
        is_expected.to contain_sendmail__mc__feature('ratecontrol')
      }
    end
  end

  context 'on unsupported osfamily' do
    let(:facts) do
      { os: { architecture: 'vax', name: 'VAX/VMS', family: 'VMS' } }
    end

    it {
      is_expected.to compile.and_raise_error(%r{Unsupported osfamily})
    }
  end
end
