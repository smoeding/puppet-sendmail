require 'spec_helper'

describe 'sendmail::mc::define' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    let(:title) { 'foobar' }
    let(:pre_condition) { 'include sendmail::service' }

    context "on #{os} with no argument" do
      it {
        is_expected.to contain_class('sendmail::mc::define_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-define-foobar') \
          .with_content(%r{^define\(`foobar', `'\)dnl$}) \
          .with_order('12') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with one argument" do
      let(:params) do
        { expansion: 'foo' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::define_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-define-foobar') \
          .with_content(%r{^define\(`foobar', `foo'\)dnl$}) \
          .with_order('12') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with one argument and explicit macro_name" do
      let(:params) do
        { expansion: 'foo', macro_name: 'baz' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::define_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-define-foobar') \
          .with_content(%r{^define\(`baz', `foo'\)dnl$}) \
          .with_order('12') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with one argument and use_quotes => true" do
      let(:params) do
        { expansion: 'foo', use_quotes: true }
      end

      it {
        is_expected.to contain_class('sendmail::mc::define_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-define-foobar') \
          .with_content(%r{^define\(`foobar', `foo'\)dnl$}) \
          .with_order('12') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with one argument and use_quotes => false" do
      let(:params) do
        { expansion: 'foo', use_quotes: false }
      end

      it {
        is_expected.to contain_class('sendmail::mc::define_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-define-foobar') \
          .with_content(%r{^define\(`foobar', foo\)dnl$}) \
          .with_order('12') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with one empty argument" do
      let(:params) do
        { expansion: '' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::define_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-define-foobar') \
          .with_content(%r{^define\(`foobar', `'\)dnl$}) \
          .with_order('12') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with ldap related argument" do
      let(:title) { 'confLDAP_FOO' }

      it {
        is_expected.to contain_class('sendmail::mc::define_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-define-confLDAP_FOO') \
          .with_content(%r{^define\(`confLDAP_FOO', `'\)dnl$}) \
          .with_order('19') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with milter related argument" do
      let(:title) { 'confMILTER_FOO' }

      it {
        is_expected.to contain_class('sendmail::mc::milter_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-define-confMILTER_FOO') \
          .with_content(%r{^define\(`confMILTER_FOO', `'\)dnl$}) \
          .with_order('56') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with milter argument confINPUT_MAIL_FILTERS" do
      let(:title) { 'confINPUT_MAIL_FILTERS' }

      it {
        is_expected.to contain_class('sendmail::mc::milter_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-define-confINPUT_MAIL_FILTERS') \
          .with_content(%r{^define\(`confINPUT_MAIL_FILTERS', `'\)dnl$}) \
          .with_order('56') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    ['SMART_HOST', 'confCF_VERSION', 'confDONT_PROBE_INTERFACES',
     'confLOG_LEVEL', 'confMAX_MESSAGE_SIZE', 'confPRIVACY_FLAGS',
     'confDOMAIN_NAME'].each do |arg|

      context "on #{os} with argument #{arg}" do
        let(:title) { arg }

        let(:params) do
          { expansion: 'foo' }
        end

        it {
          is_expected.to contain_class('sendmail::mc::define_section')
          is_expected.to contain_class('sendmail::makeall')

          is_expected.to contain_concat__fragment("sendmail_mc-define-#{arg}") \
            .with_content(%r{^define\(`#{arg}', `foo'\)dnl$}) \
            .with_order('12') \
            .that_notifies('Class[sendmail::makeall]')
        }
      end
    end

    ['confCIPHER_LIST', 'confCLIENT_SSL_OPTIONS',
     'confSERVER_SSL_OPTIONS'].each do |arg|

      context "on #{os} with argument #{arg}" do
        let(:title) { arg }

        let(:params) do
          { expansion: 'foo' }
        end

        it {
          is_expected.not_to contain_class('sendmail::mc::define_section')
          is_expected.to contain_class('sendmail::makeall')

          is_expected.to contain_concat__fragment("sendmail_mc-define-#{arg}") \
            .with_content(%r{^define\(`#{arg}', `foo'\)dnl$}) \
            .with_order('48') \
            .that_notifies('Class[sendmail::makeall]')
        }
      end
    end
  end
end
