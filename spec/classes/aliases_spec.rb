require 'spec_helper'

describe 'sendmail::aliases' do

  it { should contain_class('sendmail::aliases') }

  context 'On Debian with valid parameter hash' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :entries => { 'fred' => { 'recipient' => 'fred@example.org' } } }
    end

    it { should contain_sendmail__aliases__entry('fred') }
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
      { :entries => "fred" }
    end

    it { expect { should compile }.to raise_error(/is not a Hash/) }
  end
end
