require 'spec_helper'

describe 'sendmail::virtusertable' do
  let(:title) { 'virtusertable' }

  let :facts do
    { :operatingsystem => 'Debian' }
  end

  context 'On Debian with valid parameter hash' do
    let(:params) do
      { :entries => { 'info@example.com' => { 'value' => 'fred' } } }
    end

    it { should contain_sendmail__virtusertable__entry('info@example.com') }
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
