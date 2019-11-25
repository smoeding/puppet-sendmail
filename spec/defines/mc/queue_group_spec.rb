require 'spec_helper'

describe 'sendmail::mc::queue_group' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    let(:title) { 'foobar' }

    context "on #{os} with no argument" do
      it {
        is_expected.to contain_class('sendmail::mc::queue_group_section')

        is_expected.to contain_concat__fragment('sendmail_mc-queue_group-foobar')
          .with_content(%r{^QUEUE_GROUP\(`foobar', `'\)dnl$})
          .with_order('32')
      }
    end

    context "on #{os} with one string argument" do
      let(:params) do
        { args: 'foo' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::queue_group_section')

        is_expected.to contain_concat__fragment('sendmail_mc-queue_group-foobar')
          .with_content(%r{^QUEUE_GROUP\(`foobar', `foo'\)dnl$})
          .with_order('32')
      }
    end

    context "on #{os} with one argument and use_quotes => true" do
      let(:params) do
        { args: 'foo', use_quotes: true }
      end

      it {
        is_expected.to contain_class('sendmail::mc::queue_group_section')

        is_expected.to contain_concat__fragment('sendmail_mc-queue_group-foobar')
          .with_content(%r{^QUEUE_GROUP\(`foobar', `foo'\)dnl$})
          .with_order('32')
      }
    end

    context "on #{os} with one argument and use_quotes => false" do
      let(:params) do
        { args: 'foo', use_quotes: false }
      end

      it {
        is_expected.to contain_class('sendmail::mc::queue_group_section')

        is_expected.to contain_concat__fragment('sendmail_mc-queue_group-foobar')
          .with_content(%r{^QUEUE_GROUP\(`foobar', foo\)dnl$})
          .with_order('32')
      }
    end

    context "on #{os} with one empty argument" do
      let(:params) do
        { args: '' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::queue_group_section')

        is_expected.to contain_concat__fragment('sendmail_mc-queue_group-foobar')
          .with_content(%r{^define\(`foobar', `'\)dnl$})
          .with_order('32')
      }
    end
  end
end
