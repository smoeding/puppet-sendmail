require 'spec_helper'

describe 'sendmail::mc::domain' do
  let(:title) { 'foo' }

  it {
    should contain_concat__fragment('sendmail_mc-domain-foo') \
            .with_content(/^DOMAIN\(`foo'\)dnl$/) \
            .with_order('07') \
            .that_notifies('Class[sendmail::makeall]')
  }
end
