require 'spec_helper'

describe 'sendmail::mc::feature' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    let(:title) { 'no_default_msa' }
    let(:pre_condition) { 'include sendmail::service' }

    context "on #{os} with no argument" do
      it {
        is_expected.to contain_class('sendmail::mc::feature_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-feature-no_default_msa') \
          .with_content(%r{^FEATURE\(`no_default_msa'\)dnl$}) \
          .with_order('22') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with one argument as string" do
      let(:params) do
        { args: 'foo' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::feature_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-feature-no_default_msa') \
          .with_content(%r{^FEATURE\(`no_default_msa', `foo'\)dnl$}) \
          .with_order('22') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with one argument as array" do
      let(:params) do
        { args: ['foo'] }
      end

      it {
        is_expected.to contain_class('sendmail::mc::feature_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-feature-no_default_msa') \
          .with_content(%r{^FEATURE\(`no_default_msa', `foo'\)dnl$}) \
          .with_order('22') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with two arguments as array" do
      let(:params) do
        { args: ['foo', 'bar'] }
      end

      it {
        is_expected.to contain_class('sendmail::mc::feature_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-feature-no_default_msa') \
          .with_content(%r{^FEATURE\(`no_default_msa', `foo', `bar'\)dnl$}) \
          .with_order('22') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with one argument and explicit feature_name" do
      let(:params) do
        { args: ['foo'], feature_name: 'baz' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::feature_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-feature-no_default_msa') \
          .with_content(%r{^FEATURE\(`baz', `foo'\)dnl$}) \
          .with_order('22') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with one argument and use_quotes => true" do
      let(:params) do
        { args: ['foo'], use_quotes: true }
      end

      it {
        is_expected.to contain_class('sendmail::mc::feature_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-feature-no_default_msa') \
          .with_content(%r{^FEATURE\(`no_default_msa', `foo'\)dnl$}) \
          .with_order('22') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with one argument and use_quotes => false" do
      let(:params) do
        { args: ['foo'], use_quotes: false }
      end

      it {
        is_expected.to contain_class('sendmail::mc::feature_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-feature-no_default_msa') \
          .with_content(%r{^FEATURE\(`no_default_msa', foo\)dnl$}) \
          .with_order('22') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with one empty string as argument" do
      let(:params) do
        { args: [''] }
      end

      it {
        is_expected.to contain_class('sendmail::mc::feature_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-feature-no_default_msa') \
          .with_content(%r{^FEATURE\(`no_default_msa', `'\)dnl$}) \
          .with_order('22') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with feature ldap_routing" do
      let(:title) { 'ldap_routing' }

      it {
        is_expected.to contain_class('sendmail::mc::feature_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-feature-ldap_routing') \
          .with_content(%r{^FEATURE\(`ldap_routing'\)dnl$}) \
          .with_order('19')
      }
    end

    context "on #{os} with feature conncontrol" do
      let(:title) { 'conncontrol' }

      it {
        is_expected.to contain_class('sendmail::mc::feature_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-feature-conncontrol') \
          .with_content(%r{^FEATURE\(`conncontrol'\)dnl$}) \
          .with_order('28')
      }
    end

    context "on #{os} with feature ratecontrol" do
      let(:title) { 'ratecontrol' }

      it {
        is_expected.to contain_class('sendmail::mc::feature_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-feature-ratecontrol') \
          .with_content(%r{^FEATURE\(`ratecontrol'\)dnl$}) \
          .with_order('28')
      }
    end

    context "on #{os} with feature nullclient" do
      let(:title) { 'nullclient' }

      it {
        is_expected.to contain_class('sendmail::mc::feature_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-feature-nullclient') \
          .with_content(%r{^FEATURE\(`nullclient'\)dnl$}) \
          .with_order('29')
      }
    end

    context "on #{os} with feature no_default_msa" do
      let(:title) { 'no_default_msa' }

      it {
        is_expected.to contain_class('sendmail::mc::feature_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-feature-no_default_msa') \
          .with_content(%r{^FEATURE\(`no_default_msa'\)dnl$}) \
          .with_order('22')
      }
    end

    context "on #{os} with feature access misspelled" do
      let(:title) { 'access' }

      it {
        is_expected.to contain_class('sendmail::mc::feature_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-feature-access') \
          .with_content(%r{^FEATURE\(`access_db'\)dnl$}) \
          .with_order('22')
      }
    end
  end
end
