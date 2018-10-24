require 'spec_helper'

describe 'sendmail::mc::domain' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }

    context "on #{os} with domain_name foobar" do
      let(:title) { 'foobar' }

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-domain-foobar')
          .with_content(%r{^DOMAIN\(`foobar'\)dnl$})
          .with_order('07')
      }
    end

    context "on #{os} with domain_name debian-mta" do
      let(:title) { 'debian-mta' }

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-domain-debian-mta')
          .with_content(%r{^DOMAIN\(`debian-mta'\)dnl$})
          .with_order('07')
      }
    end

    context "on #{os} with domain_name foobar as parameter" do
      let(:title) { 'debian-mta' }
      let(:params) do
        { domain_name: 'foobar' }
      end

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-domain-foobar')
          .with_content(%r{^DOMAIN\(`foobar'\)dnl$})
          .with_order('07')
      }
    end
  end
end
