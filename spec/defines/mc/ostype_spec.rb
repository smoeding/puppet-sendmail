require 'spec_helper'

describe 'sendmail::mc::ostype' do
  context 'on Debian' do
    let(:title) { 'debian' }

    it {
      should contain_concat__fragment('sendmail_mc-ostype-debian') \
              .with_content(/^OSTYPE\(`debian'\)dnl$/) \
              .with_order('05') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'on RedHat' do
    let(:title) { 'linux' }

    it {
      should contain_concat__fragment('sendmail_mc-ostype-linux') \
              .with_content(/^OSTYPE\(`linux'\)dnl$/) \
              .with_order('05') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'on FreeBSD' do
    let(:title) { 'freebsd6' }

    it {
      should contain_concat__fragment('sendmail_mc-ostype-freebsd6') \
              .with_content(/^OSTYPE\(`freebsd6'\)dnl$/) \
              .with_order('05') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end
end
