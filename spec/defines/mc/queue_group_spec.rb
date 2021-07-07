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

    context "on #{os} with flags argument" do
      let(:params) do
        { flags: 'f' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::queue_group_section')

        is_expected.to contain_concat__fragment('sendmail_mc-queue_group-foobar')
          .with_content(%r{^QUEUE_GROUP\(`foobar', `F=f'\)dnl$})
          .with_order('32')
      }
    end

    context "on #{os} with interval argument" do
      let(:params) do
        { interval: '10m' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::queue_group_section')

        is_expected.to contain_concat__fragment('sendmail_mc-queue_group-foobar')
          .with_content(%r{^QUEUE_GROUP\(`foobar', `I=10m'\)dnl$})
          .with_order('32')
      }
    end

    context "on #{os} with jobs argument" do
      let(:params) do
        { jobs: 42 }
      end

      it {
        is_expected.to contain_class('sendmail::mc::queue_group_section')

        is_expected.to contain_concat__fragment('sendmail_mc-queue_group-foobar')
          .with_content(%r{^QUEUE_GROUP\(`foobar', `J=42'\)dnl$})
          .with_order('32')
      }
    end

    context "on #{os} with nice argument" do
      let(:params) do
        { nice: -10 }
      end

      it {
        is_expected.to contain_class('sendmail::mc::queue_group_section')

        is_expected.to contain_concat__fragment('sendmail_mc-queue_group-foobar')
          .with_content(%r{^QUEUE_GROUP\(`foobar', `N=-10'\)dnl$})
          .with_order('32')
      }
    end

    context "on #{os} with path argument" do
      let(:params) do
        { path: '/var/spool/queue' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::queue_group_section')

        is_expected.to contain_concat__fragment('sendmail_mc-queue_group-foobar')
          .with_content(%r{^QUEUE_GROUP\(`foobar', `P=/var/spool/queue'\)dnl$})
          .with_order('32')
      }
    end

    context "on #{os} with recipients argument" do
      let(:params) do
        { recipients: 1 }
      end

      it {
        is_expected.to contain_class('sendmail::mc::queue_group_section')

        is_expected.to contain_concat__fragment('sendmail_mc-queue_group-foobar')
          .with_content(%r{^QUEUE_GROUP\(`foobar', `r=1'\)dnl$})
          .with_order('32')
      }
    end

    context "on #{os} with runners argument" do
      let(:params) do
        { runners: 2 }
      end

      it {
        is_expected.to contain_class('sendmail::mc::queue_group_section')

        is_expected.to contain_concat__fragment('sendmail_mc-queue_group-foobar')
          .with_content(%r{^QUEUE_GROUP\(`foobar', `R=2'\)dnl$})
          .with_order('32')
      }
    end

    context "on #{os} with multiple arguments" do
      let(:params) do
        { path: '/var/spool/q', runners: 2, flags: 'f', jobs: 10 }
      end

      it {
        is_expected.to contain_class('sendmail::mc::queue_group_section')

        is_expected.to contain_concat__fragment('sendmail_mc-queue_group-foobar')
          .with_content(%r{^QUEUE_GROUP\(`foobar', `F=f, J=10, R=2, P=/var/spool/q'\)dnl$})
          .with_order('32')
      }
    end
  end
end
