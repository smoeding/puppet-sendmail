require 'spec_helper'

describe 'sendmail::aliases', :type => 'class' do

  context "On a Debian OS when adding a single alias" do
    let(:title) { 'aliases' }

    let(:params) do
      { :entries => { 'fred' => { 'recipient' => 'fred@example.org' } } }
    end

    let :facts do
      { :osfamily => 'Debian' }
    end

    it { should contain_class('sendmail::aliases::newaliases') }
    it { should contain_class('sendmail::aliases::file') }

    it do
      should contain_file('/etc/aliases').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })
    end

    it do
      should contain_mailalias('fred').with({
        'ensure'    => 'present',
        'recipient' => 'fred@example.org',
      }).that_notifies('Class[sendmail::aliases::newaliases]')
    end
  end

  context "On a Debian OS when removing a single alias" do
    let(:title) { 'aliases' }

    let(:params) do
      { :entries => { 'fred' => { 'ensure' => 'absent' } } }
    end

    let :facts do
      { :osfamily => 'Debian' }
    end

    it { should contain_class('sendmail::aliases::newaliases') }
    it { should contain_class('sendmail::aliases::file') }

    it do
      should contain_file('/etc/aliases').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })
    end

    it do
      should contain_mailalias('fred').with({
        'ensure' => 'absent',
      }).that_notifies('Class[sendmail::aliases::newaliases]')
    end
  end

  context "On a Debian OS when adding an alias without recipient" do
    let(:title) { 'aliases' }

    let(:params) do
      { :entries => { 'fred' => { } } }
    end

    let :facts do
      { :osfamily => 'Debian' }
    end

    it do
      expect {
        should compile
      }.to raise_error(/recipient must be set when creating an alias/)
    end
  end

end
