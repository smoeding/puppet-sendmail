require 'spec_helper'

describe 'sendmail::mc::masquerade_as' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    let(:title) { 'example.com' }
    let(:pre_condition) { 'include sendmail::service' }

    context "on #{os} with title => 'example.com'" do
      it {
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-masquerade') \
          .with_content(%r{^MASQUERADE_AS\(`example.com'\)dnl$}) \
          .without_content(%r{^FEATURE}) \
          .without_content(%r{^MASQUERADE_DOMAIN}) \
          .without_content(%r{^MASQUERADE_EXCEPTION}) \
          .without_content(%r{^EXPOSED_USER}) \
          .with_order('30') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with masquerade_domain => [ 'example.net', 'example.org' ]" do
      let(:params) do
        { masquerade_domain: ['example.net', 'example.org'] }
      end

      it {
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-masquerade') \
          .with_content(%r{^MASQUERADE_DOMAIN\(`example.net example.org'\)dnl$}) \
          .without_content(%r{^MASQUERADE_DOMAIN_FILE})
      }
    end

    context "on #{os} with masquerade_domain_file => /foo/bar" do
      let(:params) do
        { masquerade_domain_file: '/foo/bar' }
      end

      it {
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-masquerade') \
          .with_content(%r{^MASQUERADE_DOMAIN_FILE\(`\/foo\/bar'\)dnl$}) \
          .without_content(%r{^MASQUERADE_DOMAIN\(})
      }
    end
  end
end
