require 'spec_helper'

describe 'sendmail::authinfo' do
  let(:title) { 'authinfo' }

  let :facts do
    { :operatingsystem => 'Debian' }
  end

  context 'On Debian with valid parameter hash' do
    let(:params) do
      { :entries => { 'AuthInfo:example.com' => { 'value' => '"U=auth" "P=secret"' } } }
    end

    it { should contain_sendmail__authinfo__entry('AuthInfo:example.com') }
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
