require 'spec_helper'

describe 'sendmail::userdb::file' do

  it { should contain_class('sendmail::userdb::file') }

  on_supported_os.each do |os, facts|
    context "on #{os} with default parameters" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'Debian'
        it {
          should contain_file('/etc/mail/userdb').with(
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
          should contain_file('/etc/mail/userdb').with(
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
          should contain_file('/etc/mail/userdb').with(
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
      let(:params) do
        { :content => 'foo' }
      end

      it {
        should contain_file('/etc/mail/userdb').with(
                 'ensure'  => 'file',
                 'content' => 'foo',
                 'source'  => nil,
               ).that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with source => foo" do
      let(:params) do
        { :source => 'foo' }
      end

      it {
        should contain_file('/etc/mail/userdb').with(
                 'ensure'  => 'file',
                 'content' => nil,
                 'source'  => 'foo',
               ).that_notifies('Class[sendmail::makeall]')
      }
    end
  end
end
