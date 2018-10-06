require 'spec_helper'

describe 'sendmail::access::file' do
  let(:pre_condition) { 'include sendmail::service' }

  on_supported_os.each do |os, facts|
    context "on #{os} with default parameters" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'Debian'
        it {
          is_expected.to contain_class('sendmail::access::file')
          is_expected.to contain_file('/etc/mail/access').with(
            'ensure'  => 'file',
            'owner'   => 'smmta',
            'group'   => 'smmsp',
            'mode'    => '0640',
            'content' => nil,
            'source'  => nil,
          ).that_notifies('Class[sendmail::makeall]')
        }
      when 'RedHat'
        it {
          is_expected.to contain_class('sendmail::access::file')
          is_expected.to contain_file('/etc/mail/access').with(
            'ensure'  => 'file',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0640',
            'content' => nil,
            'source'  => nil,
          ).that_notifies('Class[sendmail::makeall]')
        }
      when 'FreeBSD'
        it {
          is_expected.to contain_class('sendmail::access::file')
          is_expected.to contain_file('/etc/mail/access').with(
            'ensure'  => 'file',
            'owner'   => 'root',
            'group'   => 'wheel',
            'mode'    => '0640',
            'content' => nil,
            'source'  => nil,
          ).that_notifies('Class[sendmail::makeall]')
        }
      end
    end

    context "on #{os} with content => foo" do
      let(:facts) { facts }

      let(:params) do
        { content: 'foo' }
      end

      it {
        is_expected.to contain_file('/etc/mail/access').with(
          'ensure'  => 'file',
          'content' => 'foo',
          'source'  => nil,
        ).that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with source => foo" do
      let(:facts) { facts }

      let(:params) do
        { source: 'foo' }
      end

      it {
        is_expected.to contain_file('/etc/mail/access').with(
          'ensure'  => 'file',
          'content' => nil,
          'source'  => 'foo',
        ).that_notifies('Class[sendmail::makeall]')
      }
    end
  end
end
