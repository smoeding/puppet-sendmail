require 'spec_helper'

describe 'sendmail::service' do
  on_supported_os.each do |os, facts|
    context "on #{os} with default parameters" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'Debian'
        it {
          is_expected.to contain_class('sendmail::service')
          is_expected.to contain_service('sendmail')
            .with_ensure('running')
            .with_name('sendmail')
            .with_enable(true)
            .with_hasstatus(false)
        }
      when 'RedHat', 'FreeBSD'
        it {
          is_expected.to contain_class('sendmail::service')
          is_expected.to contain_service('sendmail')
            .with_ensure('running')
            .with_name('sendmail')
            .with_enable(true)
            .with_hasstatus(true)
        }
      end
    end

    context "on #{os} with service_manage => false" do
      let(:facts) { facts }
      let(:params) do
        { service_manage: false }
      end

      it { is_expected.not_to contain_service('sendmail') }
    end

    context "on #{os} with service_ensure => stopped" do
      let(:facts) { facts }
      let(:params) do
        { service_ensure: 'stopped' }
      end

      it { is_expected.to contain_service('sendmail').with_ensure('stopped') }
    end

    context "on #{os} with service_ensure => running" do
      let(:facts) { facts }
      let(:params) do
        { service_ensure: 'running' }
      end

      it { is_expected.to contain_service('sendmail').with_ensure('running') }
    end

    context "on #{os} with service_ensure => true" do
      let(:facts) { facts }
      let(:params) do
        { service_ensure: true }
      end

      it { is_expected.to contain_service('sendmail').with_ensure('running') }
    end

    context "on #{os} with service_ensure => false" do
      let(:facts) { facts }
      let(:params) do
        { service_ensure: false }
      end

      it { is_expected.to contain_service('sendmail').with_ensure('stopped') }
    end

    context "on #{os} with service_enable => true" do
      let(:facts) { facts }
      let(:params) do
        { service_enable: true }
      end

      it { is_expected.to contain_service('sendmail').with_enable('true') }
    end

    context "on #{os} with service_enable => false" do
      let(:facts) { facts }
      let(:params) do
        { service_enable: false }
      end

      it { is_expected.to contain_service('sendmail').with_enable('false') }
    end

    context "on #{os} with service_name set" do
      let(:facts) { facts }
      let(:params) do
        { service_name: 'sendmoremail' }
      end

      it { is_expected.to contain_service('sendmail').with_name('sendmoremail') }
    end

    context "on #{os} with service_hasstatus => true" do
      let(:facts) { facts }
      let(:params) do
        { service_hasstatus: 'true' }
      end

      it { is_expected.to contain_service('sendmail').with_hasstatus('true') }
    end

    context "on #{os} with service_hasstatus => false" do
      let(:facts) { facts }
      let(:params) do
        { service_hasstatus: 'false' }
      end

      it { is_expected.to contain_service('sendmail').with_hasstatus('false') }
    end
  end
end
