require 'spec_helper'

describe 'sendmail::localhostnames' do
  let(:title) { 'localhostnames' }

  let :facts do
    { :osfamily => 'Debian' }
  end

  context 'On Debian with valid parameter hash' do
    let(:params) do
      { :entries => { 'localhost' => {} } }
    end

    it { should contain_sendmail__localhostnames__entry('localhost') }
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
      { :entries => "localhost" }
    end

    it do
      expect { should compile }.to raise_error(/is not a Hash/)
    end
  end
end
