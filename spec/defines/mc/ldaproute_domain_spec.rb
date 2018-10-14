require 'spec_helper'

describe 'sendmail::mc::ldaproute_domain' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    let(:pre_condition) { 'include sendmail::service' }

    context "on #{os} with domain example.net" do
      let(:title) { 'example.net' }

      it {
        is_expected.to contain_class('sendmail::mc::ldap_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-ldaproute_domain-example.net')
          .with_content(%r{^LDAPROUTE_DOMAIN\(`example.net'\)dnl$})
          .with_order('19')
          .that_notifies('Class[sendmail::makeall]')
      }
    end
  end
end
