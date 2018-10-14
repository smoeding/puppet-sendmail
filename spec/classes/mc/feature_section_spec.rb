require 'spec_helper'

describe 'sendmail::mc::feature_section' do
  let(:pre_condition) { 'include sendmail::service' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-feature_header')
          .with_content(%r{^dnl # Features$})
          .with_order('20')
      }
    end
  end
end
