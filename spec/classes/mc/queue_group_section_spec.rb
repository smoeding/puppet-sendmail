require 'spec_helper'

describe 'sendmail::mc::queue_group_section' do
  let(:pre_condition) { 'include sendmail::service' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-queue_group_header')
          .with_content(%r{^dnl # Queue Group$})
          .with_order('33')
      }
    end
  end
end
