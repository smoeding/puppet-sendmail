require 'spec_helper'

describe 'sendmail::domaintable' do

  it { should contain_class('sendmail::domaintable') }

  context 'On Debian with valid parameter hash' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :entries => { 'example.com' => { 'value' => 'example.org' } } }
    end

    it { should contain_sendmail__domaintable__entry('example.com') }
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
