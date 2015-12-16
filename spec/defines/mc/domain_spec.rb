require 'spec_helper'

describe 'sendmail::mc::domain' do

  context 'with domain foobar' do
    let(:title) { 'foobar' }

    it {
      should contain_concat__fragment('sendmail_mc-domain-foobar') \
              .with_content(/^DOMAIN\(`foobar'\)dnl$/) \
              .with_order('07') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with domain debian-mta' do
    let(:title) { 'debian-mta' }

    it {
      should contain_concat__fragment('sendmail_mc-domain-debian-mta') \
              .with_content(/^DOMAIN\(`debian-mta'\)dnl$/) \
              .with_order('07') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end
end
