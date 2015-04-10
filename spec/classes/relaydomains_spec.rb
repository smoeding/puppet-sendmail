require 'spec_helper'

describe 'sendmail::relaydomains' do
  let(:title) { 'relaydomains' }

  let :facts do
    { :operatingsystem => 'Debian' }
  end

  context 'On Debian with valid parameter hash' do
    let(:params) do
      { :entries => { 'example.org' => {} } }
    end

    it { should contain_sendmail__relaydomains__entry('example.org') }
  end

  context 'On Debian with empty parameter hash' do
    let(:params) do
      { :entries => { } }
    end

    it do
      expect { should compile }
    end
  end

  context 'On Debian with wrong parameter type' do
    let(:params) do
      { :entries => "example.org" }
    end

    it do
      expect { should compile }.to raise_error(/is not a Hash/)
    end
  end
end
