require 'spec_helper'

describe 'sendmail::userdb' do

  context 'with valid parameter hash' do
    let(:params) do
      { :entries => { 'fred:maildrop' => { 'value' => 'fred@example.com' } } }
    end

    it { should contain_sendmail__userdb__entry('fred:maildrop') }
  end

  context 'with empty parameter hash' do
    let(:params) do
      { :entries => { } }
    end

    it { expect { should compile } }
  end

  context 'with wrong parameter type' do
    let(:params) do
      { :entries => "example.com" }
    end

    it { expect { should compile }.to raise_error(/is not a Hash/) }
  end
end
