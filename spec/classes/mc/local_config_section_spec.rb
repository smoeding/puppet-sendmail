require 'spec_helper'

describe 'sendmail::mc::local_config_section' do
  let(:pre_condition) { 'include sendmail::service' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-local_config_header')
          .with_content(%r{^LOCAL_CONFIG})
          .with_target('sendmail.mc')
          .with_order('80')
      }
    end
  end
end
