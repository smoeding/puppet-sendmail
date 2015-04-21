require 'spec_helper'

describe 'sendmail::trusted_users' do
  let(:title) { 'trusted_users' }

  let(:facts) do
    { :operatingsystem => 'Debian' }
  end

  context 'On Debian with valid parameter hash' do
    let(:params) do
      { :entries => { 'fred' => {} } }
    end

    it { should contain_sendmail__trusted_users__entry('fred') }
  end

  context 'On Debian with empty parameter hash' do
    let(:params) do
      { :entries => { } }
    end

    it {
      expect { should compile }
    }
  end

  context 'On Debian with wrong parameter type' do
    let(:params) do
      { :entries => "fred" }
    end

    it {
      expect { should compile }.to raise_error(/is not a Hash/)
    }
  end
end
