require 'spec_helper'

describe 'sendmail::mc::mailer' do

  context 'with mailer smtp' do
    let(:title) { 'smtp' }

    it {
      should contain_concat__fragment('sendmail_mc-mailer-smtp') \
              .with_content(/^MAILER\(`smtp'\)dnl$/) \
              .with_order('61') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::mailer_section')
    }
  end

  context 'with mailer local' do
    let(:title) { 'local' }

    it {
      should contain_concat__fragment('sendmail_mc-mailer-local') \
              .with_content(/^MAILER\(`local'\)dnl$/) \
              .with_order('65') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::mailer_section')
    }
  end

  context 'with mailer foobar' do
    let(:title) { 'foobar' }

    it {
      should contain_concat__fragment('sendmail_mc-mailer-foobar') \
              .with_content(/^MAILER\(`foobar'\)dnl$/) \
              .with_order('69') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::mailer_section')
    }
  end
end
