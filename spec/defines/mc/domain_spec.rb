require 'spec_helper'

describe 'sendmail::mc::domain' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    let(:pre_condition) { 'include sendmail::service' }

    context "on #{os} with domainname foobar" do
      let(:title) { 'foobar' }

      it {
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-domain-foobar') \
          .with_content(%r{^DOMAIN\(`foobar'\)dnl$}) \
          .with_order('07') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with domainname debian-mta" do
      let(:title) { 'debian-mta' }

      it {
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-domain-debian-mta') \
          .with_content(%r{^DOMAIN\(`debian-mta'\)dnl$}) \
          .with_order('07') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with domainname foobar as parameter" do
      let(:title) { 'debian-mta' }
      let(:params) do
        { domainname: 'foobar' }
      end

      it {
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-domain-foobar')
          .with_content(%r{^DOMAIN\(`foobar'\)dnl$})
          .with_order('07')
          .that_notifies('Class[sendmail::makeall]')
      }
    end
  end
end
