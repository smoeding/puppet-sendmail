require 'spec_helper'

describe 'sendmail::virtusertable' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    let(:pre_condition) { 'include sendmail::service' }

    context "on #{os} with content => foo" do
      let(:params) do
        { content: 'foo' }
      end

      it {
        is_expected.to contain_class('sendmail::virtusertable')
        is_expected.to contain_class('sendmail::virtusertable::file')
          .with_content('foo')
          .without_source
      }
    end

    context "on #{os} with source => foo" do
      let(:params) do
        { source: 'foo' }
      end

      it {
        is_expected.to contain_class('sendmail::virtusertable')
        is_expected.to contain_class('sendmail::virtusertable::file')
          .without_content
          .with_source('foo')
      }
    end

    context "on #{os} with source and content set" do
      let(:params) do
        { source: 'foo', content: 'foo' }
      end

      it {
        is_expected.to compile.and_raise_error(%r{cannot specify more than})
      }
    end

    context "on #{os} with source and entries set" do
      let(:params) do
        {
          source:  'foo',
          entries: { 'info@example.com' => { 'value' => 'fred' } },
        }
      end

      it {
        is_expected.to compile.and_raise_error(%r{cannot specify more than})
      }
    end

    context "on #{os} with content and entries set" do
      let(:params) do
        {
          content: 'foo',
          entries: { 'info@example.com' => { 'value' => 'fred' } },
        }
      end

      it {
        is_expected.to compile.and_raise_error(%r{cannot specify more than})
      }
    end

    context "on #{os} with valid parameter hash" do
      let(:params) do
        { entries: { 'info@example.com' => { 'value' => 'fred' } } }
      end

      it {
        is_expected.to contain_sendmail__virtusertable__entry('info@example.com')
      }
    end

    context "on #{os} with empty parameter hash" do
      let(:params) do
        { entries: {} }
      end

      it {
        is_expected.to compile
      }
    end
  end
end
