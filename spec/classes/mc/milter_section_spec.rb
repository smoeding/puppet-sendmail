require 'spec_helper'

describe 'sendmail::mc::milter_section' do
  let(:pre_condition) { 'include sendmail::service' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-milter_header')
          .with_content(%r{^dnl # Milter$})
          .with_order('55')
      }
    end
  end
end
