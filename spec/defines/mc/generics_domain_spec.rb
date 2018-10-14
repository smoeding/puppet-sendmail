require 'spec_helper'

describe 'sendmail::mc::generics_domain' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    let(:pre_condition) { 'include sendmail::service' }

    context "on #{os} with domain example.net" do
      let(:title) { 'example.net' }

      it {
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-generics_domain-example.net')
          .with_content(%r{^GENERICS_DOMAIN\(`example.net'\)dnl$})
          .with_order('32')
          .that_notifies('Class[sendmail::makeall]')
      }
    end
  end
end
