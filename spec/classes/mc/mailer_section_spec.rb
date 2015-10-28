require 'spec_helper'

describe 'sendmail::mc::mailer_section' do

  it { should contain_class('sendmail::mc::mailer_section') }

  context 'with no arguments' do
    it {
      should contain_concat__fragment('sendmail_mc-mailer_header') \
              .with_content(/^dnl # Mailer$/) \
              .with_order('60') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end
end
