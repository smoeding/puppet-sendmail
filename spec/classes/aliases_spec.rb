require 'spec_helper'

describe 'sendmail::aliases' do
  let(:title) { 'aliases' }

  let :facts do
    { :operatingsystem => 'Debian' }
  end

  context 'On Debian with valid parameter hash' do
    let(:params) do
      { :entries => { 'fred' => { 'recipient' => 'fred@example.org' } } }
    end

    it { should contain_sendmail__aliases__entry('fred') }
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
