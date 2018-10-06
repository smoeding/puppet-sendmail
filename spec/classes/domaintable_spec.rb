require 'spec_helper'

describe 'sendmail::domaintable' do
  let(:pre_condition) { 'include sendmail::service' }

  on_supported_os.each do |os, facts|
    context "on #{os} with content => foo" do
      let(:facts) { facts }
      let(:params) do
        { content: 'foo' }
      end

      it {
        is_expected.to contain_class('sendmail::domaintable')
        is_expected.to contain_class('sendmail::domaintable::file').with(
          'content' => 'foo',
          'source'  => nil,
        )
      }
    end

    context "on #{os} with source => foo" do
      let(:facts) { facts }
      let(:params) do
        { source: 'foo' }
      end

      it {
        is_expected.to contain_class('sendmail::domaintable')
        is_expected.to contain_class('sendmail::domaintable::file').with(
          'content' => nil,
          'source'  => 'foo',
        )
      }
    end

    context "on #{os} with source and content set" do
      let(:facts) { facts }
      let(:params) do
        { source: 'foo', content: 'foo' }
      end

      it {
        is_expected.to compile.and_raise_error(%r{cannot specify more than})
      }
    end

    context "on #{os} with source and entries set" do
      let(:facts) { facts }
      let(:params) do
        {
          source:  'foo',
          entries: { 'example.com' => { 'value' => 'example.org' } },
        }
      end

      it {
        is_expected.to compile.and_raise_error(%r{cannot specify more than})
      }
    end

    context "on #{os} with content and entries set" do
      let(:facts) { facts }
      let(:params) do
        {
          content: 'foo',
          entries: { 'example.com' => { 'value' => 'example.org' } },
        }
      end

      it {
        is_expected.to compile.and_raise_error(%r{cannot specify more than})
      }
    end

    context "on #{os} with valid parameter hash" do
      let(:facts) { facts }
      let(:params) do
        { entries: { 'example.com' => { 'value' => 'example.org' } } }
      end

      it {
        is_expected.to contain_sendmail__domaintable__entry('example.com')
      }
    end

    context "on #{os} with empty parameter hash" do
      let(:facts) { facts }
      let(:params) do
        { entries: {} }
      end

      it { is_expected.to compile }
    end

    context "on #{os} with wrong parameter type" do
      let(:facts) { facts }
      let(:params) do
        { entries: 'example.com' }
      end

      it { is_expected.to compile.and_raise_error(%r{is not a Hash}) }
    end
  end
end
