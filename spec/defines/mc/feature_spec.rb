require 'spec_helper'

describe 'sendmail::mc::feature' do
  let(:title) { 'foobar' }

  context 'with no argument' do
    it {
      should contain_concat__fragment('sendmail_mc-feature-foobar') \
              .with_content(/^FEATURE\(`foobar'\)dnl$/) \
              .with_order('22') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::feature_section')
    }
  end

  context 'with one argument' do
    let(:params) do
      { :args => [ 'foo' ] }
    end

    it {
      should contain_concat__fragment('sendmail_mc-feature-foobar') \
              .with_content(/^FEATURE\(`foobar', `foo'\)dnl$/) \
              .with_order('22') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::feature_section')
    }
  end

  context 'with two arguments' do
    let(:params) do
      { :args => [ 'foo', 'bar' ] }
    end

    it {
      should contain_concat__fragment('sendmail_mc-feature-foobar') \
              .with_content(/^FEATURE\(`foobar', `foo', `bar'\)dnl$/) \
              .with_order('22') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::feature_section')
    }
  end

  context 'with one argument and explicit feature_name' do
    let(:params) do
      { :args => [ 'foo' ], :feature_name => 'baz' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-feature-foobar') \
              .with_content(/^FEATURE\(`baz', `foo'\)dnl$/) \
              .with_order('22') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::feature_section')
    }
  end

  context 'with one argument and use_quotes => true' do
    let(:params) do
      { :args => [ 'foo' ], :use_quotes => true }
    end

    it {
      should contain_concat__fragment('sendmail_mc-feature-foobar') \
              .with_content(/^FEATURE\(`foobar', `foo'\)dnl$/) \
              .with_order('22') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::feature_section')
    }
  end

  context 'with one argument and use_quotes => false' do
    let(:params) do
      { :args => [ 'foo' ], :use_quotes => false }
    end

    it {
      should contain_concat__fragment('sendmail_mc-feature-foobar') \
              .with_content(/^FEATURE\(`foobar', foo\)dnl$/) \
              .with_order('22') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::feature_section')
    }
  end

  context 'with one empty string as argument' do
    let(:params) do
      { :args => [ '' ] }
    end

    it {
      should contain_concat__fragment('sendmail_mc-feature-foobar') \
              .with_content(/^FEATURE\(`foobar', `'\)dnl$/) \
              .with_order('22') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::feature_section')
    }
  end

  context 'with feature ldap_routing' do
    let(:title) { 'ldap_routing' }

    it {
      should contain_concat__fragment('sendmail_mc-feature-ldap_routing') \
              .with_order('19')
      should contain_class('sendmail::mc::feature_section')
    }
  end

  context 'with feature conncontrol' do
    let(:title) { 'conncontrol' }

    it {
      should contain_concat__fragment('sendmail_mc-feature-conncontrol') \
              .with_order('28')
      should contain_class('sendmail::mc::feature_section')
    }
  end

  context 'with feature ratecontrol' do
    let(:title) { 'ratecontrol' }

    it {
      should contain_concat__fragment('sendmail_mc-feature-ratecontrol') \
              .with_order('28')
      should contain_class('sendmail::mc::feature_section')
    }
  end

  context 'with feature nullclient' do
    let(:title) { 'nullclient' }

    it {
      should contain_concat__fragment('sendmail_mc-feature-nullclient') \
              .with_order('29')
      should contain_class('sendmail::mc::feature_section')
    }
  end
end
