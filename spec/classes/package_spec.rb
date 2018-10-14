require 'spec_helper'

describe 'sendmail::package' do
  on_supported_os.each do |os, facts|
    context "on #{os} with default parameters" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'Debian'
        it {
          is_expected.to contain_class('sendmail::package')
            .with_package_manage(true)

          is_expected.to contain_package('sendmail')
        }
      when 'RedHat'
        it {
          is_expected.to contain_class('sendmail::package')
            .with_package_manage(true)

          is_expected.to contain_package('sendmail')
          is_expected.to contain_package('sendmail-cf')
        }
      when 'FreeBSD'
        it {
          is_expected.to contain_class('sendmail::package')
            .with_package_manage(false)

          is_expected.not_to contain_package('sendmail')
        }
      end
    end

    context "on #{os} with package_ensure => latest" do
      let(:facts) { facts }
      let(:params) do
        { package_ensure: 'latest' }
      end

      case facts[:osfamily]
      when 'Debian'
        it {
          is_expected.to contain_package('sendmail').with_ensure('latest')
        }
      when 'RedHat'
        it {
          is_expected.to contain_package('sendmail').with_ensure('latest')
          is_expected.to contain_package('sendmail-cf')
        }
      when 'FreeBSD'
        it {
          is_expected.not_to contain_package('sendmail')
        }
      end
    end

    context "on #{os} with package_manage => false" do
      let(:facts) { facts }
      let(:params) do
        { package_manage: false }
      end

      it { is_expected.not_to contain_package('sendmail') }
    end

    context "on #{os} with auxiliary_packages defined" do
      let(:facts) { facts }
      let(:params) do
        { auxiliary_packages: ['foo', 'bar'] }
      end

      case facts[:os#family]
      when 'Debian', 'RedHat'
        it {
          is_expected.to contain_package('foo')
          is_expected.to contain_package('bar')
        }
      when 'FreeBSD'
        it {
          is_expected.not_to contain_package('foo')
          is_expected.not_to contain_package('bar')
        }
      end
    end
  end
end
