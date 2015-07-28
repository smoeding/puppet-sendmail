require 'spec_helper'

describe 'sendmail::authinfo' do

  context 'with valid parameter hash' do
    let(:params) do
      { :entries => { 'example.com' => { 'value' => '"U=auth" "P=secret"' } } }
    end

    it { should contain_sendmail__authinfo__entry('example.com') }
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
