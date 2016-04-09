require 'spec_helper'

describe 'sendmail::service' do

  it { should contain_class('sendmail::service') }

  on_supported_os.each do |os, facts|
    context "on #{os} with default parameters" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'Debian'
        it {
          should contain_service('sendmail').with(
                   'ensure'    => 'running',
                   'name'      => 'sendmail',
                   'enable'    => 'true',
                   'hasstatus' => 'false',
                 )
        }
      else
        it {
          should contain_service('sendmail').with(
                   'ensure'    => 'running',
                   'name'      => 'sendmail',
                   'enable'    => 'true',
                   'hasstatus' => 'true',
                 )
        }
      end
    end

    context "on #{os} with service_manage => false" do
      let(:params) do
        { :service_manage => false }
      end

      it { should_not contain_service('sendmail') }
    end

    context "on #{os} with service_ensure => stopped" do
      let(:params) do
        { :service_ensure => 'stopped' }
      end

      it { should contain_service('sendmail').with_ensure('stopped') }
    end

    context "on #{os} with service_ensure => running" do
      let(:params) do
        { :service_ensure => 'running' }
      end

      it { should contain_service('sendmail').with_ensure('running') }
    end

    context "on #{os} with service_ensure => true" do
      let(:params) do
        { :service_ensure => true }
      end

      it { should contain_service('sendmail').with_ensure('running') }
    end

    context "on #{os} with service_ensure => false" do
      let(:params) do
        { :service_ensure => false }
      end

      it { should contain_service('sendmail').with_ensure('stopped') }
    end

    context "on #{os} with service_enable => true" do
      let(:params) do
        { :service_enable => true }
      end

      it { should contain_service('sendmail').with_enable('true') }
    end

    context "on #{os} with service_enable => false" do
      let(:params) do
        { :service_enable => false }
      end

      it { should contain_service('sendmail').with_enable('false') }
    end

    context "on #{os} with service_name set" do
      let(:params) do
        { :service_name => 'sendmoremail' }
      end

      it { should contain_service('sendmail').with_name('sendmoremail') }
    end

    context "on #{os} with service_hasstatus => true" do
      let(:params) do
        { :service_hasstatus => 'true' }
      end

      it { should contain_service('sendmail').with_hasstatus('true') }
    end

    context "on #{os} with service_hasstatus => false" do
      let(:params) do
        { :service_hasstatus => 'false' }
      end

      it { should contain_service('sendmail').with_hasstatus('false') }
    end
  end
end
