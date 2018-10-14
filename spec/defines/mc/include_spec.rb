require 'spec_helper'

describe 'sendmail::mc::include' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    let(:pre_condition) { 'include sendmail::service' }

    context "on #{os} with include file" do
      let(:title) { '/foo' }

      it {
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-include-/foo')
          .with_content(%r{^include\(`\/foo'\)dnl$})
          .with_order('59')
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with order => xx" do
      let(:title) { '/foo' }

      let(:params) do
        { order: 'xx' }
      end

      it {
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-include-/foo')
          .with_content(%r{^include\(`\/foo'\)dnl$})
          .with_order('xx')
          .that_notifies('Class[sendmail::makeall]')
      }
    end
  end
end
