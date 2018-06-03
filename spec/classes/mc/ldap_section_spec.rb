require 'spec_helper'

describe 'sendmail::mc::ldap_section' do
  let(:pre_condition) {
    'include sendmail::service'
  }

  context 'with no arguments' do
    it {
      should contain_class('sendmail::makeall')

      should contain_concat__fragment('sendmail_mc-ldap_header') \
              .with_content(/^dnl # LDAP$/) \
              .with_order('18') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end
end
