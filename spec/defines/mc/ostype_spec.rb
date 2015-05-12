require 'spec_helper'

describe 'sendmail::mc::ostype' do
  let(:title) { 'foonly' }

  it {
    should contain_concat__fragment('sendmail_mc-ostype-foonly') \
            .with_content(/^OSTYPE\(`foonly'\)dnl$/) \
            .with_order('05') \
            .that_notifies('Class[sendmail::makeall]')
  }
end
