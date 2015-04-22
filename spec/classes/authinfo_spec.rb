require 'spec_helper'

describe 'sendmail::authinfo' do

  context 'On Debian with valid parameter hash' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :entries => { 'AuthInfo:example.com' => { 'value' => '"U=auth" "P=secret"' } } }
    end

    it { should contain_sendmail__authinfo__entry('AuthInfo:example.com') }
  end

  context 'On Debian with empty parameter hash' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :entries => { } }
    end

    it { expect { should compile } }
  end

  context 'On Debian with wrong parameter type' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :entries => "example.com" }
    end

    it { expect { should compile }.to raise_error(/is not a Hash/) }
  end
end
