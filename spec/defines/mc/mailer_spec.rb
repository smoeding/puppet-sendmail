require 'spec_helper'

describe 'sendmail::mc::mailer' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }

    context "on #{os} with mailer smtp" do
      let(:title) { 'smtp' }

      it {
        is_expected.to contain_class('sendmail::mc::mailer_section')

        is_expected.to contain_concat__fragment('sendmail_mc-mailer-smtp')
          .with_content(%r{^MAILER\(`smtp'\)dnl$})
          .with_order('61')
      }
    end

    context "on #{os} with mailer local" do
      let(:title) { 'local' }

      it {
        is_expected.to contain_class('sendmail::mc::mailer_section')

        is_expected.to contain_concat__fragment('sendmail_mc-mailer-local')
          .with_content(%r{^MAILER\(`local'\)dnl$})
          .with_order('65')
      }
    end

    context "on #{os} with mailer foobar" do
      let(:title) { 'foobar' }

      it {
        is_expected.to contain_class('sendmail::mc::mailer_section')

        is_expected.to contain_concat__fragment('sendmail_mc-mailer-foobar')
          .with_content(%r{^MAILER\(`foobar'\)dnl$})
          .with_order('69')
      }
    end
  end
end
