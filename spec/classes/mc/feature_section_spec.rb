require 'spec_helper'

describe 'sendmail::mc::feature_section' do
  let(:pre_condition) {
    'include sendmail::service'
  }

  context 'with no arguments' do
    it {
      should contain_class('sendmail::makeall')

      should contain_concat__fragment('sendmail_mc-feature_header') \
              .with_content(/^dnl # Features$/) \
              .with_order('20') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end
end
