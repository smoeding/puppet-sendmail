require 'spec_helper'

describe 'sendmail::aliases::file' do
  on_supported_os.each do |os, facts|
    context "on #{os} with default parameters" do
      let(:facts) { facts }

      it {
        case facts[:osfamily]
        when 'Debian', 'RedHat'
          is_expected.to contain_class('sendmail::aliases::file')
          is_expected.to contain_class('sendmail::aliases::newaliases')
          is_expected.to contain_file('/etc/aliases').with(
            'ensure'  => 'file',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
            'content' => nil,
            'source'  => nil,
          ).that_notifies('Class[sendmail::aliases::newaliases]')
        when 'FreeBSD'
          is_expected.to contain_class('sendmail::aliases::file')
          is_expected.to contain_class('sendmail::aliases::newaliases')
          is_expected.to contain_file('/etc/mail/aliases').with(
            'ensure'  => 'file',
            'owner'   => 'root',
            'group'   => 'wheel',
            'mode'    => '0644',
            'content' => nil,
            'source'  => nil,
          ).that_notifies('Class[sendmail::aliases::newaliases]')
        end
      }
    end

    context "on #{os} with content => foo" do
      let(:facts) { facts }
      let(:params) do
        { content: 'foo' }
      end

      it {
        case facts[:osfamily]
        when 'Debian', 'RedHat'
          is_expected.to contain_file('/etc/aliases').with(
            'ensure'  => 'file',
            'content' => 'foo',
            'source'  => nil,
          ).that_notifies('Class[sendmail::aliases::newaliases]')
        when 'FreeBSD'
          is_expected.to contain_file('/etc/mail/aliases').with(
            'ensure'  => 'file',
            'content' => 'foo',
            'source'  => nil,
          ).that_notifies('Class[sendmail::aliases::newaliases]')
        end
      }
    end

    context "on #{os} with source => foo" do
      let(:facts) { facts }
      let(:params) do
        { source: 'foo' }
      end

      it {
        case facts[:osfamily]
        when 'Debian', 'RedHat'
          is_expected.to contain_file('/etc/aliases').with(
            'ensure'  => 'file',
            'content' => nil,
            'source'  => 'foo',
          ).that_notifies('Class[sendmail::aliases::newaliases]')
        when 'FreeBSD'
          is_expected.to contain_file('/etc/mail/aliases').with(
            'ensure'  => 'file',
            'content' => nil,
            'source'  => 'foo',
          ).that_notifies('Class[sendmail::aliases::newaliases]')
        end
      }
    end
  end
end
