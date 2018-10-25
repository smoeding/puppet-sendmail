require 'spec_helper'

describe 'sendmail::mc::trust_auth_mech' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }

    context "on #{os} with string argument" do
      let(:params) do
        { trust_auth_mech: 'bar' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::macro_section')

        is_expected.to contain_concat__fragment('sendmail_mc-trust_auth_mech')
          .with_content(%r{^TRUST_AUTH_MECH\(`bar'\)dnl$})
          .with_order('45')
      }
    end

    context "on #{os} with array argument" do
      let(:params) do
        { trust_auth_mech: ['bar', 'baz'] }
      end

      it {
        is_expected.to contain_class('sendmail::mc::macro_section')

        is_expected.to contain_concat__fragment('sendmail_mc-trust_auth_mech')
          .with_content(%r{^TRUST_AUTH_MECH\(`bar baz'\)dnl$})
          .with_order('45')
      }
    end

    context "on #{os} with empty array argument" do
      let(:params) do
        { trust_auth_mech: [] }
      end

      it {
        is_expected.to contain_class('sendmail::mc::macro_section')

        is_expected.to contain_concat__fragment('sendmail_mc-trust_auth_mech')
          .with_content(%r{^TRUST_AUTH_MECH\(`'\)dnl$})
          .with_order('45')
      }
    end
  end
end
