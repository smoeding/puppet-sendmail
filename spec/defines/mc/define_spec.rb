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

  context 'with argument SMART_HOST' do
    let(:title) { 'SMART_HOST' }

    let(:params) do
      { :expansion => 'foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-define-SMART_HOST') \
              .with_content(/^define\(`SMART_HOST', `foo'\)dnl$/) \
              .with_order('12') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::define_section')
    }
  end

  context 'with argument confCF_VERSION' do
    let(:title) { 'confCF_VERSION' }

    let(:params) do
      { :expansion => 'foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-define-confCF_VERSION') \
              .with_content(/^define\(`confCF_VERSION', `foo'\)dnl$/) \
              .with_order('12') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::define_section')
    }
  end

  context 'with argument confDONT_PROBE_INTERFACES' do
    let(:title) { 'confDONT_PROBE_INTERFACES' }

    let(:params) do
      { :expansion => 'foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-define-confDONT_PROBE_INTERFACES') \
              .with_content(/^define\(`confDONT_PROBE_INTERFACES', `foo'\)dnl$/) \
              .with_order('12') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::define_section')
    }
  end

  context 'with argument confLOG_LEVEL' do
    let(:title) { 'confLOG_LEVEL' }

    let(:params) do
      { :expansion => 'foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-define-confLOG_LEVEL') \
              .with_content(/^define\(`confLOG_LEVEL', `foo'\)dnl$/) \
              .with_order('12') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::define_section')
    }
  end

  context 'with argument confMAX_MESSAGE_SIZE' do
    let(:title) { 'confMAX_MESSAGE_SIZE' }

    let(:params) do
      { :expansion => 'foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-define-confMAX_MESSAGE_SIZE') \
              .with_content(/^define\(`confMAX_MESSAGE_SIZE', `foo'\)dnl$/) \
              .with_order('12') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::define_section')
    }
  end

  context 'with argument confCIPHER_LIST' do
    let(:title) { 'confCIPHER_LIST' }

    let(:params) do
      { :expansion => 'foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-define-confCIPHER_LIST') \
              .with_content(/^define\(`confCIPHER_LIST', `foo'\)dnl$/) \
              .with_order('12') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::define_section')
    }
  end

  context 'with argument confCLIENT_SSL_OPTIONS' do
    let(:title) { 'confCLIENT_SSL_OPTIONS' }

    let(:params) do
      { :expansion => 'foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-define-confCLIENT_SSL_OPTIONS') \
              .with_content(/^define\(`confCLIENT_SSL_OPTIONS', `foo'\)dnl$/) \
              .with_order('12') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::define_section')
    }
  end

  context 'with argument confSERVER_SSL_OPTIONS' do
    let(:title) { 'confSERVER_SSL_OPTIONS' }

    let(:params) do
      { :expansion => 'foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-define-confSERVER_SSL_OPTIONS') \
              .with_content(/^define\(`confSERVER_SSL_OPTIONS', `foo'\)dnl$/) \
              .with_order('12') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::define_section')
    }
  end
end
