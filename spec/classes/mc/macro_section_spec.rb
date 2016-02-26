require 'spec_helper'

describe 'sendmail::mc::macro_section' do

  it { should contain_class('sendmail::mc::macro_section') }

  context 'with no arguments' do
    it {
      should contain_concat__fragment('sendmail_mc-macro_header') \
              .with_content(/^dnl # Macros$/) \
              .with_order('31') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end
end
