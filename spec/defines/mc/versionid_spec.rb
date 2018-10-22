require 'spec_helper'

describe 'sendmail::mc::versionid' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    let(:title) { 'foo' }

    context "on #{os} with title only" do
      it {
        is_expected.to contain_concat__fragment('sendmail_mc-versionid')
          .with_content(%r{^VERSIONID\(`foo'\)dnl$})
          .with_order('01')
      }
    end

    context "on #{os} with versionid => foo" do
      let(:params) do
        { versionid: 'bar' }
      end

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-versionid')
          .with_content(%r{^VERSIONID\(`bar'\)dnl$})
          .with_order('01')
      }
    end
  end
end
