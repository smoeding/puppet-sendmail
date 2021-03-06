require 'spec_helper'

describe 'sendmail::mc::mailer_section' do
  let(:pre_condition) { 'include sendmail::service' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-mailer_header')
          .with_content(%r{^dnl # Mailer$})
          .with_order('60')
      }
    end
  end
end
