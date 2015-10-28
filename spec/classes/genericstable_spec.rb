require 'spec_helper'

describe 'sendmail::genericstable' do

  it { should contain_class('sendmail::genericstable') }

  context 'On Debian with valid parameter hash' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :entries => { 'user@example.com' => { 'value' => 'user@example.org' } } }
    end

    it { should contain_sendmail__genericstable__entry('user@example.com') }
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
      { :entries => "example.com" }
    end

    it { expect { should compile }.to raise_error(/is not a Hash/) }
  end
end
