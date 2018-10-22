require 'spec_helper'

describe 'sendmail::mc::enhdnsbl' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    let(:title) { 'bl.example.com' }

    context "on #{os} with defaults" do
      it {
        is_expected.to contain_class('sendmail::mc::enhdnsbl_section')

        is_expected.to contain_concat__fragment('sendmail_mc-enhdnsbl_bl.example.com')
          .with_content(%r{^FEATURE\(`enhdnsbl', `bl.example.com'\)dnl$})
          .with_order('51')
      }
    end

    context "on #{os} with reject_message => foo" do
      let(:params) do
        { reject_message: 'foo' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::enhdnsbl_section')

        is_expected.to contain_concat__fragment('sendmail_mc-enhdnsbl_bl.example.com')
          .with_content(%r{`bl.example.com', `foo'\)dnl$})
      }
    end

    context "on #{os} with allow_temporary_failure => true" do
      let(:params) do
        { allow_temporary_failure: true }
      end

      it {
        is_expected.to contain_class('sendmail::mc::enhdnsbl_section')

        is_expected.to contain_concat__fragment('sendmail_mc-enhdnsbl_bl.example.com')
          .with_content(%r{`bl.example.com', , `t'\)dnl$})
      }
    end

    context "on #{os} with lookup_result => foo" do
      let(:params) do
        { lookup_result: 'foo' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::enhdnsbl_section')

        is_expected.to contain_concat__fragment('sendmail_mc-enhdnsbl_bl.example.com')
          .with_content(%r{`bl.example.com', , , `foo'\)dnl$})
      }
    end
  end
end
