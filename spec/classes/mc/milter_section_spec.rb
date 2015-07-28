require 'spec_helper'

describe 'sendmail::mc::milter_section' do

  context 'with no arguments' do
    it {
      should contain_concat__fragment('sendmail_mc-milter_header') \
              .with_content(/^dnl # Milter$/) \
              .with_order('55') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end
end
