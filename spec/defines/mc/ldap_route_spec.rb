require 'spec_helper'

describe 'sendmail::mc::ldaproute_domain' do
  let(:pre_condition) {
    'include sendmail::service'
  }

  context 'with domain example.net' do
    let(:title) { 'example.net' }

    it {
      should contain_concat__fragment('sendmail_mc-ldaproute_domain-example.net') \
              .with_content(/^LDAPROUTE_DOMAIN\(`example.net'\)dnl$/) \
              .with_order('19') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::ldap_section')
    }
  end
end
