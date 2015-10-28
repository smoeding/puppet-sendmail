require 'spec_helper'

describe 'sendmail::package' do

  it { should contain_class('sendmail::package') }

  context 'On Debian with defaults' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    it {
      should contain_package('sendmail')
      should contain_package('bsd-mailx')
    }
  end

  context 'On Rehat with defaults' do
    let(:facts) do
      { :operatingsystem => 'Redhat' }
    end

    it {
      should contain_package('sendmail')
      should contain_package('sendmail-cf')
      should contain_package('cyrus-sasl')
      should contain_package('m4')
      should contain_package('mailx')
      should contain_package('make')
    }
  end

  context 'with package_ensure => latest' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :package_ensure => 'latest' }
    end

    it {
      should contain_package('sendmail').with_ensure('latest')
    }
  end

  context 'with package_manage => false' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :package_manage => false }
    end

    it { should_not contain_package('sendmail') }
  end

  context 'with auxiliary_packages defined' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :auxiliary_packages => [ 'foo', 'bar' ] }
    end

    it {
      should contain_package('foo')
      should contain_package('bar')
    }
  end
end
