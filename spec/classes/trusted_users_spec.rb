require 'spec_helper'

describe 'sendmail::trusted_users' do

  it { should contain_class('sendmail::trusted_users') }

  on_supported_os.each do |os, facts|
    context "on #{os} with default parameters" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'Debian'
        it {
          should contain_file('/etc/mail/trusted-users').with(
                   'ensure'  => 'file',
                   'owner'   => 'root',
                   'group'   => 'smmsp',
                   'mode'    => '0644',
                   'content' => '',
                 )
        }
      when 'RedHat'
        it {
          should contain_file('/etc/mail/trusted-users').with(
                   'ensure'  => 'file',
                   'owner'   => 'root',
                   'group'   => 'root',
                   'mode'    => '0644',
                   'content' => '',
                 )
        }
      when 'FreeBSD'
        it {
          should contain_file('/etc/mail/trusted-users').with(
                   'ensure'  => 'file',
                   'owner'   => 'root',
                   'group'   => 'wheel',
                   'mode'    => '0644',
                   'content' => '',
                 )
        }
      end
    end

    context "on #{os} with string parameter type" do
      let(:params) do
        { :trusted_users => "root" }
      end

      it { expect { should compile }.to raise_error(/is not an Array/) }
    end

    context "on #{os} with empty parameter" do
      let(:params) do
        { :trusted_users => [] }
      end

      it {
        should contain_file('/etc/mail/trusted-users')
      }
    end

    context "on #{os} with single element array" do
      let(:params) do
        { :trusted_users => [ 'foo' ] }
      end

      it {
        should contain_file('/etc/mail/trusted-users').with(
                 'content' => "foo\n",
               )
      }
    end

    context "on #{os} with multiple element array" do
      let(:params) do
        { :trusted_users => [ 'foo', 'bar', 'baz' ] }
      end

      it {
        should contain_file('/etc/mail/trusted-users').with(
                 'content' => "bar\nbaz\nfoo\n",
               )
      }
    end
  end
end
