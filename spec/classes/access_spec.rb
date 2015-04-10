require 'spec_helper'

describe 'sendmail::access' do
  let(:title) { 'access' }

  let :facts do
    { :operatingsystem => 'Debian' }
  end

  context 'On Debian with valid parameter hash' do
    let(:params) do
      { :entries => { 'example.com' => { 'value' => 'OK' } } }
    end

    it { should contain_sendmail__access__entry('example.com') }
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
      { :entries => "example.com" }
    end

    it do
      expect { should compile }.to raise_error(/is not a Hash/)
    end
  end
end
