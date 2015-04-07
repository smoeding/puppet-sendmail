require 'spec_helper'

describe 'sendmail::aliases', :type => 'class' do

  context "On a Debian OS with single alias specified" do
    let(:title) { 'aliases' }

    let(:params) do
      { :entries => { 'fred' => { 'recipient' => 'fred@example.org' } } }
    end

    let :facts do
      { :osfamily => 'Debian' }
    end

    it { should contain_class('sendmail::aliases::newaliases') }

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
      })
    end
  end
end
