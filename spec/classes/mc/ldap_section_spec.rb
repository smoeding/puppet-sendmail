require 'spec_helper'

describe 'sendmail::mc::ldap_section' do
  let(:pre_condition) { 'include sendmail::service' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-ldap_header')
          .with_content(%r{^dnl # LDAP$})
          .with_order('18')
      }
    end
  end
end
