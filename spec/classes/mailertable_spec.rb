require 'spec_helper'

describe 'sendmail::mailertable' do

  it { should contain_class('sendmail::mailertable') }

  context 'On Debian with content => foo' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :content => 'foo' }
    end

    it {
      should contain_class('sendmail::mailertable::file').with(
               'content' => 'foo',
               'source'  => nil,
             )
    }
  end

  context 'On Debian with source => foo' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :source => 'foo' }
    end

    it {
      should contain_class('sendmail::mailertable::file').with(
               'content' => nil,
               'source'  => 'foo',
             )
    }
  end

  context 'On Debian with source and content set' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :source => 'foo', :content => 'foo' }
    end

    it { expect { should compile }.to raise_error(/cannot specify more than/) }
  end

  context 'On Debian with source and entries set' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      {
        :source  => 'foo',
        :entries => { '.example.com' => { 'value' => 'smtp:relay.example.com' } }
      }
    end

    it { expect { should compile }.to raise_error(/cannot specify more than/) }
  end

  context 'On Debian with content and entries set' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      {
        :content => 'foo',
        :entries => { '.example.com' => { 'value' => 'smtp:relay.example.com' } }
      }
    end

    it { expect { should compile }.to raise_error(/cannot specify more than/) }
  end

  context 'On Debian with valid parameter hash' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :entries => { '.example.com' => { 'value' => 'smtp:relay.example.com' } } }
    end

    it { should contain_sendmail__mailertable__entry('.example.com') }
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
      { :entries => '.example.com' }
    end

    it { expect { should compile }.to raise_error(/is not a Hash/) }
  end
end
