require 'spec_helper'

describe 'sendmail::relay_domains' do
  let(:title) { 'relay_domains' }

  let(:facts) do
    { :operatingsystem => 'Debian' }
  end

  context 'On Debian with valid parameter hash' do
    let(:params) do
      { :entries => { 'example.org' => {} } }
    end

    it { should contain_sendmail__relay_domains__entry('example.org') }
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
      { :entries => "example.org" }
    end

    it {
      expect { should compile }.to raise_error(/is not a Hash/)
    }
  end
end
