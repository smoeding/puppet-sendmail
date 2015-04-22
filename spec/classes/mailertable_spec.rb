require 'spec_helper'

describe 'sendmail::mailertable' do

  context 'On Debian with valid parameter hash' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :entries => { '.example.com' => { 'value' => 'smtp:relay.example.com' } } }
    end

    it { should contain_sendmail__mailertable__entry('.example.com') }
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
      { :entries => ".example.com" }
    end

    it { expect { should compile }.to raise_error(/is not a Hash/) }
  end
end
