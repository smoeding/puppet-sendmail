require 'spec_helper'

describe 'sendmail::mc::define_section' do
  let(:pre_condition) {
    'include sendmail::service'
  }

  context 'with no arguments' do
    it {
      should contain_class('sendmail::makeall')

      should contain_concat__fragment('sendmail_mc-define_header') \
              .with_content(/^dnl # Defines$/) \
              .with_order('10') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end
end
