require 'spec_helper'

describe 'sendmail::mc::trust_auth_mech' do
  let(:title) { 'trust_auth_mech' }

  context 'with resource title only' do
    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-trust_auth_mech') \
            .with_content(/^TRUST_AUTH_MECH\(`trust_auth_mech'\)dnl$/) \
            .with_order('45') \
            .that_notifies('Class[sendmail::makeall]')

    }
  end

  context 'with title and string argument' do
    let(:params) do
      { :trust_auth_mech => 'bar' }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-trust_auth_mech') \
            .with_content(/^TRUST_AUTH_MECH\(`bar'\)dnl$/) \
            .with_order('45') \
            .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with title and empty string argument' do
    let(:params) do
      { :trust_auth_mech => '' }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-trust_auth_mech') \
            .with_content(/^TRUST_AUTH_MECH\(`'\)dnl$/) \
            .with_order('45') \
            .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with title and array argument' do
    let(:params) do
      { :trust_auth_mech => [ 'bar', 'baz' ] }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-trust_auth_mech') \
            .with_content(/^TRUST_AUTH_MECH\(`bar baz'\)dnl$/) \
            .with_order('45') \
            .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with title and empty array argument' do
    let(:params) do
      { :trust_auth_mech => [] }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-trust_auth_mech') \
            .with_content(/^TRUST_AUTH_MECH\(`'\)dnl$/) \
            .with_order('45') \
            .that_notifies('Class[sendmail::makeall]')
    }
  end
end
