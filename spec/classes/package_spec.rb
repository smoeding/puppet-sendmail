require 'spec_helper'

describe 'sendmail::package' do

  it { should contain_class('sendmail::package') }

  context 'On Debian with defaults' do
    let(:facts) do
      {
        :operatingsystem => 'Debian',
        :osfamily        => 'Debian'
      }
    end

    it {
      should contain_class('sendmail::package').with('package_manage' => true)
      should contain_package('sendmail')
    }
  end

  context 'On ReHat with defaults' do
    let(:facts) do
      {
        :operatingsystem => 'RedHat',
        :osfamily        => 'RedHat'
      }
    end

    it {
      should contain_class('sendmail::package').with('package_manage' => true)
      should contain_package('sendmail')
      should contain_package('sendmail-cf')
    }
  end

  context 'On FreeBSD with defaults' do
    let(:facts) do
      {
        :operatingsystem => 'FreeBSD',
        :osfamily        => 'FreeBSD'
      }
    end

    it {
      should contain_class('sendmail::package').with('package_manage' => false)
      should_not contain_package('sendmail')
    }
  end

  context 'with package_ensure => latest' do
    let(:params) do
      { :package_ensure => 'latest' }
    end

    it {
      should contain_package('sendmail').with_ensure('latest')
    }
  end

  context 'with package_manage => false' do
    let(:params) do
      { :package_manage => false }
    end

    it { should_not contain_package('sendmail') }
  end

  context 'with auxiliary_packages defined' do
    let(:params) do
      { :auxiliary_packages => [ 'foo', 'bar' ] }
    end

    it {
      should contain_package('foo')
      should contain_package('bar')
    }
  end
end
