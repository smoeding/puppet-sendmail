require 'spec_helper'

describe 'sendmail::mc::trust_auth_mech' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    let(:title) { 'trust_auth_mech' }
    let(:pre_condition) { 'include sendmail::service' }

    context "on #{os} with resource title only" do
      it {
        is_expected.to contain_class('sendmail::mc::macro_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-trust_auth_mech')
          .with_content(%r{^TRUST_AUTH_MECH\(`trust_auth_mech'\)dnl$})
          .with_order('45')
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with title and string argument" do
      let(:params) do
        { trust_auth_mech: 'bar' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::macro_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-trust_auth_mech')
          .with_content(%r{^TRUST_AUTH_MECH\(`bar'\)dnl$})
          .with_order('45')
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with title and empty string argument" do
      let(:params) do
        { trust_auth_mech: '' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::macro_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-trust_auth_mech')
          .with_content(%r{^TRUST_AUTH_MECH\(`'\)dnl$})
          .with_order('45')
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with title and array argument" do
      let(:params) do
        { trust_auth_mech: ['bar', 'baz'] }
      end

      it {
        is_expected.to contain_class('sendmail::mc::macro_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-trust_auth_mech')
          .with_content(%r{^TRUST_AUTH_MECH\(`bar baz'\)dnl$})
          .with_order('45')
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with title and empty array argument" do
      let(:params) do
        { trust_auth_mech: [] }
      end

      it {
        is_expected.to contain_class('sendmail::mc::macro_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-trust_auth_mech')
          .with_content(%r{^TRUST_AUTH_MECH\(`'\)dnl$})
          .with_order('45')
          .that_notifies('Class[sendmail::makeall]')
      }
    end
  end
end
