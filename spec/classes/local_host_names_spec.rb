require 'spec_helper'

describe 'sendmail::local_host_names' do
  let(:title) { 'local_host_names' }

  let(:facts) do
    { :operatingsystem => 'Debian' }
  end

  context 'On Debian with valid parameter hash' do
    let(:params) do
      { :entries => { 'localhost' => {} } }
    end

    it { should contain_sendmail__local_host_names__entry('localhost') }
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
      { :entries => "localhost" }
    end

    it {
      expect { should compile }.to raise_error(/is not a Hash/)
    }
  end
end
