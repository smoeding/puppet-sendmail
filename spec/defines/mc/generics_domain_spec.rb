require 'spec_helper'

describe 'sendmail::mc::generics_domain' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }

    context "on #{os} with domain_name example.net" do
      let(:title) { 'example.net' }

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-generics_domain_name-example.net')
          .with_content(%r{^GENERICS_DOMAIN\(`example.net'\)dnl$})
          .with_order('32')
      }
    end
  end
end
