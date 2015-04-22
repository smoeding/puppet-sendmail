require 'spec_helper'

describe 'sendmail::mailertable' do
  let(:title) { 'mailertable' }

  let(:facts) do
    { :operatingsystem => 'Debian' }
  end

  context 'On Debian with valid parameter hash' do
    let(:params) do
      { :entries => { '.example.com' => { 'value' => 'smtp:relay.example.com' } } }
    end

    it { should contain_sendmail__mailertable__entry('.example.com') }
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
      { :entries => ".example.com" }
    end

    it do
      expect { should compile }.to raise_error(/is not a Hash/)
    end
  end
end
