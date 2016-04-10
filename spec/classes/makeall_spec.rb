require 'spec_helper'

describe 'sendmail::makeall' do

  it { should contain_class('sendmail::makeall') }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'FreeBSD'
        it {
          should contain_exec('sendmail::makeall') \
                  .with_command('make -C /etc/mail all install') \
                  .that_requires('Class[sendmail::package]')
        }
      else
        it {
          should contain_exec('sendmail::makeall') \
                  .with_command('make -C /etc/mail all') \
                  .that_requires('Class[sendmail::package]')
        }
      end
    end
  end
end
