require 'spec_helper'

describe 'sendmail::mc::define_section' do
  let(:pre_condition) { 'include sendmail::service' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it {
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-define_header') \
          .with_content(%r{^dnl # Defines$}) \
          .with_order('10') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end
  end
end
