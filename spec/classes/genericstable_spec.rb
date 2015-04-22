require 'spec_helper'

describe 'sendmail::genericstable' do
  let(:title) { 'genericstable' }

  let(:facts) do
    { :operatingsystem => 'Debian' }
  end

  context 'On Debian with valid parameter hash' do
    let(:params) do
      { :entries => { 'user@example.com' => { 'value' => 'user@example.org' } } }
    end

    it { should contain_sendmail__genericstable__entry('user@example.com') }
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
