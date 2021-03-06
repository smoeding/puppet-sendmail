require 'spec_helper'

describe 'sendmail::mc::ldaproute_domain' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }

    context "on #{os} with domain_name example.net" do
      let(:title) { 'example.net' }

      it {
        is_expected.to contain_class('sendmail::mc::ldap_section')

        is_expected.to contain_concat__fragment('sendmail_mc-ldaproute_domain_name-example.net')
          .with_content(%r{^LDAPROUTE_DOMAIN\(`example.net'\)dnl$})
          .with_order('19')
      }
    end
  end
end
