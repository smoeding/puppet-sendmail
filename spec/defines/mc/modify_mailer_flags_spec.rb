require 'spec_helper'

describe 'sendmail::mc::modify_mailer_flags' do
  let(:title) { 'foobar' }

  context 'with one argument' do
    let(:params) do
      { :flags => 'foo' }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-modify_mailer_flags-foobar') \
              .with_content(/^MODIFY_MAILER_FLAGS\(`foobar', `foo'\)dnl$/) \
              .with_order('38') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with one argument and explicit macro_name' do
    let(:params) do
      { :flags => 'foo', :mailer_name => 'baz' }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-modify_mailer_flags-foobar') \
              .with_content(/^MODIFY_MAILER_FLAGS\(`baz', `foo'\)dnl$/) \
              .with_order('38') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with one argument and use_quotes => true' do
    let(:params) do
      { :flags => 'foo', :use_quotes => true }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-modify_mailer_flags-foobar') \
              .with_content(/^MODIFY_MAILER_FLAGS\(`foobar', `foo'\)dnl$/) \
              .with_order('38') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with one argument and use_quotes => false' do
    let(:params) do
      { :flags => 'foo', :use_quotes => false }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-modify_mailer_flags-foobar') \
              .with_content(/^MODIFY_MAILER_FLAGS\(`foobar', foo\)dnl$/) \
              .with_order('38') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end
end
