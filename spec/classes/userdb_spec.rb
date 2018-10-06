require 'spec_helper'

describe 'sendmail::userdb' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    let(:pre_condition) { 'include sendmail::service' }

    context "on #{os} with content => foo" do
      let(:params) do
        { content: 'foo' }
      end

      it {
        is_expected.to contain_class('sendmail::userdb')
        is_expected.to contain_class('sendmail::userdb::file').with(
          'content' => 'foo',
          'source'  => nil,
        )
      }
    end

    context "on #{os} with source => foo" do
      let(:params) do
        { source: 'foo' }
      end

      it {
        is_expected.to contain_class('sendmail::userdb')
        is_expected.to contain_class('sendmail::userdb::file').with(
          'content' => nil,
          'source'  => 'foo',
        )
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
          entries: { 'fred:maildrop' => { 'value' => 'fred@example.com' } },
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
          entries: { 'fred:maildrop' => { 'value' => 'fred@example.com' } },
        }
      end

      it {
        is_expected.to compile.and_raise_error(%r{cannot specify more than})
      }
    end

    context "on #{os} with valid parameter hash" do
      let(:params) do
        { entries: { 'fred:maildrop' => { 'value' => 'fred@example.com' } } }
      end

      it {
        is_expected.to contain_sendmail__userdb__entry('fred:maildrop')
      }
    end

    context "on #{os} with empty parameter hash" do
      let(:params) do
        { entries: {} }
      end

      it { is_expected.to compile }
    end

    context "on #{os} with wrong parameter type" do
      let(:params) do
        { entries: 'example.com' }
      end

      it {
        is_expected.to compile.and_raise_error(%r{is not a Hash})
      }
    end
  end
end
