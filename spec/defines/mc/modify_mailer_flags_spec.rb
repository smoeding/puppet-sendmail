require 'spec_helper'

describe 'sendmail::mc::modify_mailer_flags' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    let(:title) { 'foobar' }
    let(:pre_condition) { 'include sendmail::service' }

    context "on #{os} with one argument" do
      let(:params) do
        { flags: 'foo' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::macro_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-modify_mailer_flags-foobar') \
          .with_content(%r{^MODIFY_MAILER_FLAGS\(`foobar', `foo'\)dnl$}) \
          .with_order('38') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with one argument and explicit macro_name" do
      let(:params) do
        { flags: 'foo', mailer_name: 'baz' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::macro_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-modify_mailer_flags-foobar') \
          .with_content(%r{^MODIFY_MAILER_FLAGS\(`baz', `foo'\)dnl$}) \
          .with_order('38') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with one argument and use_quotes => true" do
      let(:params) do
        { flags: 'foo', use_quotes: true }
      end

      it {
        is_expected.to contain_class('sendmail::mc::macro_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-modify_mailer_flags-foobar') \
          .with_content(%r{^MODIFY_MAILER_FLAGS\(`foobar', `foo'\)dnl$}) \
          .with_order('38') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with one argument and use_quotes => false" do
      let(:params) do
        { flags: 'foo', use_quotes: false }
      end

      it {
        is_expected.to contain_class('sendmail::mc::macro_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-modify_mailer_flags-foobar') \
          .with_content(%r{^MODIFY_MAILER_FLAGS\(`foobar', foo\)dnl$}) \
          .with_order('38') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end
  end
end
