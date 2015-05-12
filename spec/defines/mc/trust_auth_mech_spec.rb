require 'spec_helper'

describe 'sendmail::mc::trust_auth_mech' do

  context 'trust_auth_mech with resource title only' do
    let(:title) { 'foo' }

    it {
      should contain_concat__fragment('sendmail_mc-trust_auth_mech') \
            .with_content(/^TRUST_AUTH_MECH\(`foo'\)dnl$/) \
            .with_order('45') \
            .that_notifies('Class[sendmail::makeall]')

    }
  end

  context 'trust_auth_mech with title and string argument' do
    let(:title) { 'foo' }

    let(:params) do
      { :trust_auth_mech => 'bar' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-trust_auth_mech') \
            .with_content(/^TRUST_AUTH_MECH\(`bar'\)dnl$/)
    }
  end

  context 'trust_auth_mech with title and empty string argument' do
    let(:title) { 'foo' }

    let(:params) do
      { :trust_auth_mech => '' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-trust_auth_mech') \
            .with_content(/^TRUST_AUTH_MECH\(`'\)dnl$/)
    }
  end

  context 'trust_auth_mech with title and array argument' do
    let(:title) { 'foo' }

    let(:params) do
      { :trust_auth_mech => [ 'bar', 'baz' ] }
    end

    it {
      should contain_concat__fragment('sendmail_mc-trust_auth_mech') \
            .with_content(/^TRUST_AUTH_MECH\(`bar baz'\)dnl$/)
    }
  end

  context 'trust_auth_mech with title and empty array argument' do
    let(:title) { 'foo' }

    let(:params) do
      { :trust_auth_mech => [] }
    end

    it {
      should contain_concat__fragment('sendmail_mc-trust_auth_mech') \
            .with_content(/^TRUST_AUTH_MECH\(`'\)dnl$/)
    }
  end
end
