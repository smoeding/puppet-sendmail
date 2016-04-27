require 'spec_helper'

describe 'sendmail::mc::define' do
  let(:title) { 'foobar' }

  context 'with no argument' do
    it {
      should contain_concat__fragment('sendmail_mc-define-foobar') \
              .with_content(/^define\(`foobar', `'\)dnl$/) \
              .with_order('12') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::define_section')
    }
  end

  context 'with one argument' do
    let(:params) do
      { :expansion => 'foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-define-foobar') \
              .with_content(/^define\(`foobar', `foo'\)dnl$/) \
              .with_order('12') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::define_section')
    }
  end

  context 'with one argument and explicit macro_name' do
    let(:params) do
      { :expansion => 'foo', :macro_name => 'baz' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-define-foobar') \
              .with_content(/^define\(`baz', `foo'\)dnl$/) \
              .with_order('12') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::define_section')
    }
  end

  context 'with one argument and use_quotes => true' do
    let(:params) do
      { :expansion => 'foo', :use_quotes => true }
    end

    it {
      should contain_concat__fragment('sendmail_mc-define-foobar') \
              .with_content(/^define\(`foobar', `foo'\)dnl$/) \
              .with_order('12') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::define_section')
    }
  end

  context 'with one argument and use_quotes => false' do
    let(:params) do
      { :expansion => 'foo', :use_quotes => false }
    end

    it {
      should contain_concat__fragment('sendmail_mc-define-foobar') \
              .with_content(/^define\(`foobar', foo\)dnl$/) \
              .with_order('12') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::define_section')
    }
  end

  context 'with one empty argument' do
    let(:params) do
      { :expansion => '' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-define-foobar') \
              .with_content(/^define\(`foobar', `'\)dnl$/) \
              .with_order('12') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::define_section')
    }
  end

  context 'with ldap related argument' do
    let(:title) { 'confLDAP_FOO' }

    it {
      should contain_concat__fragment('sendmail_mc-define-confLDAP_FOO') \
              .with_content(/^define\(`confLDAP_FOO', `'\)dnl$/) \
              .with_order('19') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::define_section')
    }
  end

  [ 'SMART_HOST', 'confCF_VERSION', 'confDONT_PROBE_INTERFACES',
    'confLOG_LEVEL', 'confMAX_MESSAGE_SIZE', 'confCIPHER_LIST',
    'confCLIENT_SSL_OPTIONS', 'confSERVER_SSL_OPTIONS',
    'confPRIVACY_FLAGS', 'confDOMAIN_NAME' ].each do |arg|

    context "with argument #{arg}" do
      let(:title) { arg }

      let(:params) do
        { :expansion => 'foo' }
      end

      it {
        should contain_concat__fragment("sendmail_mc-define-#{arg}") \
                .with_content(/^define\(`#{arg}', `foo'\)dnl$/) \
                .with_order('12') \
                .that_notifies('Class[sendmail::makeall]')
        should contain_class('sendmail::mc::define_section')
      }
    end
  end
end
