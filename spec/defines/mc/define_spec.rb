require 'spec_helper'

describe 'sendmail::mc::define' do
  let(:pre_condition) {
    'include sendmail::service'
  }

  let(:title) { 'foobar' }

  context 'with no argument' do
    it {
      should contain_class('sendmail::mc::define_section')
      should contain_class('sendmail::makeall')

      should contain_concat__fragment('sendmail_mc-define-foobar') \
              .with_content(/^define\(`foobar', `'\)dnl$/) \
              .with_order('12') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with one argument' do
    let(:params) do
      { :expansion => 'foo' }
    end

    it {
      should contain_class('sendmail::mc::define_section')
      should contain_class('sendmail::makeall')

      should contain_concat__fragment('sendmail_mc-define-foobar') \
              .with_content(/^define\(`foobar', `foo'\)dnl$/) \
              .with_order('12') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with one argument and explicit macro_name' do
    let(:params) do
      { :expansion => 'foo', :macro_name => 'baz' }
    end

    it {
      should contain_class('sendmail::mc::define_section')
      should contain_class('sendmail::makeall')

      should contain_concat__fragment('sendmail_mc-define-foobar') \
              .with_content(/^define\(`baz', `foo'\)dnl$/) \
              .with_order('12') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with one argument and use_quotes => true' do
    let(:params) do
      { :expansion => 'foo', :use_quotes => true }
    end

    it {
      should contain_class('sendmail::mc::define_section')
      should contain_class('sendmail::makeall')

      should contain_concat__fragment('sendmail_mc-define-foobar') \
              .with_content(/^define\(`foobar', `foo'\)dnl$/) \
              .with_order('12') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with one argument and use_quotes => false' do
    let(:params) do
      { :expansion => 'foo', :use_quotes => false }
    end

    it {
      should contain_class('sendmail::mc::define_section')
      should contain_class('sendmail::makeall')

      should contain_concat__fragment('sendmail_mc-define-foobar') \
              .with_content(/^define\(`foobar', foo\)dnl$/) \
              .with_order('12') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with one empty argument' do
    let(:params) do
      { :expansion => '' }
    end

    it {
      should contain_class('sendmail::mc::define_section')
      should contain_class('sendmail::makeall')

      should contain_concat__fragment('sendmail_mc-define-foobar') \
              .with_content(/^define\(`foobar', `'\)dnl$/) \
              .with_order('12') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with ldap related argument' do
    let(:title) { 'confLDAP_FOO' }

    it {
      should contain_class('sendmail::mc::define_section')
      should contain_class('sendmail::makeall')

      should contain_concat__fragment('sendmail_mc-define-confLDAP_FOO') \
              .with_content(/^define\(`confLDAP_FOO', `'\)dnl$/) \
              .with_order('19') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with milter related argument' do
    let(:title) { 'confMILTER_FOO' }

    it {
      should contain_class('sendmail::mc::milter_section')
      should contain_class('sendmail::makeall')

      should contain_concat__fragment('sendmail_mc-define-confMILTER_FOO') \
              .with_content(/^define\(`confMILTER_FOO', `'\)dnl$/) \
              .with_order('56') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with milter argument confINPUT_MAIL_FILTERS' do
    let(:title) { 'confINPUT_MAIL_FILTERS' }

    it {
      should contain_class('sendmail::mc::milter_section')
      should contain_class('sendmail::makeall')

      should contain_concat__fragment('sendmail_mc-define-confINPUT_MAIL_FILTERS') \
              .with_content(/^define\(`confINPUT_MAIL_FILTERS', `'\)dnl$/) \
              .with_order('56') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  [ 'SMART_HOST', 'confCF_VERSION', 'confDONT_PROBE_INTERFACES',
    'confLOG_LEVEL', 'confMAX_MESSAGE_SIZE', 'confPRIVACY_FLAGS',
    'confDOMAIN_NAME' ].each do |arg|

    context "with argument #{arg}" do
      let(:title) { arg }

      let(:params) do
        { :expansion => 'foo' }
      end

      it {
        should contain_class('sendmail::mc::define_section')
        should contain_class('sendmail::makeall')

        should contain_concat__fragment("sendmail_mc-define-#{arg}") \
                .with_content(/^define\(`#{arg}', `foo'\)dnl$/) \
                .with_order('12') \
                .that_notifies('Class[sendmail::makeall]')
      }
    end
  end

  [ 'confCIPHER_LIST', 'confCLIENT_SSL_OPTIONS',
    'confSERVER_SSL_OPTIONS', ].each do |arg|

    context "with argument #{arg}" do
      let(:title) { arg }

      let(:params) do
        { :expansion => 'foo' }
      end

      it {
        should_not contain_class('sendmail::mc::define_section')
        should contain_class('sendmail::makeall')

        should contain_concat__fragment("sendmail_mc-define-#{arg}") \
                .with_content(/^define\(`#{arg}', `foo'\)dnl$/) \
                .with_order('48') \
                .that_notifies('Class[sendmail::makeall]')
      }
    end
  end

end
