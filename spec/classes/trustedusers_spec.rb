require 'spec_helper'

describe 'sendmail::trustedusers' do
  let(:title) { 'trustedusers' }

  let :facts do
    { :operatingsystem => 'Debian' }
  end

  context 'On Debian with valid parameter hash' do
    let(:params) do
      { :entries => { 'fred' => {} } }
    end

    it { should contain_sendmail__trustedusers__entry('fred') }
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
      { :entries => "fred" }
    end

    it do
      expect { should compile }.to raise_error(/is not a Hash/)
    end
  end
end
