require 'spec_helper'

describe 'sendmail::makeall' do
  let(:pre_condition) { 'include sendmail::service' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'Debian', 'RedHat'
        it {
          is_expected.to contain_exec('sendmail::makeall') \
            .with_command('make -C /etc/mail all') \
            .that_requires('Class[sendmail::package]')
        }
      when 'FreeBSD'
        it {
          is_expected.to contain_exec('sendmail::makeall') \
            .with_command('make -C /etc/mail all install') \
            .that_requires('Class[sendmail::package]')
        }
      end
    end
  end
end
