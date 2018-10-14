require 'spec_helper'

describe 'sendmail::aliases::newaliases' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it {
        is_expected.to contain_class('sendmail::params')
        is_expected.to contain_exec('sendmail::aliases::newaliases')
          .with_command('/usr/sbin/sendmail -bi')
          .with_refreshonly('true')
      }
    end
  end
end
