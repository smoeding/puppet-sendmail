require 'spec_helper'

describe 'sendmail::mc::enhdnsbl_section' do
  let(:pre_condition) { 'include sendmail::service' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-enhdnsbl_header')
          .with_content(%r{^dnl # DNS Blacklists$})
          .with_order('50')
      }
    end
  end
end
