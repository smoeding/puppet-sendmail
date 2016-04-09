require 'spec_helper'

describe 'sendmail::package' do

  it { should contain_class('sendmail::package') }

  on_supported_os.each do |os, facts|
    context "on #{os} with default parameters" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'Debian'
        it {
          should contain_class('sendmail::package').with(
                   'package_manage' => true
                 )
          should contain_package('sendmail')
        }
      when 'RedHat'
        it {
          should contain_class('sendmail::package').with(
                   'package_manage' => true
                 )
          should contain_package('sendmail')
          should contain_package('sendmail-cf')
        }
      when 'FreeBSD'
        it {
          should contain_class('sendmail::package').with(
                   'package_manage' => false
                 )
          should_not contain_package('sendmail')
        }
      end
    end

    context "on #{os} with package_ensure => latest" do
      let(:params) do
        { :package_ensure => 'latest' }
      end

      it {
        should contain_package('sendmail').with_ensure('latest')
      }
    end

    context "on #{os} with package_manage => false" do
      let(:params) do
        { :package_manage => false }
      end

      it { should_not contain_package('sendmail') }
    end

    context "on #{os} with auxiliary_packages defined" do
      let(:params) do
        { :auxiliary_packages => [ 'foo', 'bar' ] }
      end

      it {
        should contain_package('foo')
        should contain_package('bar')
      }
    end
  end
end
