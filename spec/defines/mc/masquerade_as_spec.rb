require 'spec_helper'

describe 'sendmail::mc::masquerade_as' do
  let(:title) { 'example.com' }

  context 'example.com' do
    it {
      should contain_concat__fragment('sendmail_mc-masquerade') \
              .with_content(/^MASQUERADE_AS\(`example.com'\)dnl$/) \
              .without_content(/^FEATURE/) \
              .without_content(/^MASQUERADE_DOMAIN/) \
              .without_content(/^MASQUERADE_EXCEPTION/) \
              .without_content(/^EXPOSED_USER/) \
              .with_order('30') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context "with masquerade_domain => [ 'example.net', 'example.org' ]" do
    let(:params) do
      { :masquerade_domain => [ 'example.net', 'example.org' ] }
    end

    it {
      should contain_concat__fragment('sendmail_mc-masquerade') \
              .with_content(/^MASQUERADE_DOMAIN\(`example.net example.org'\)dnl$/) \
              .without_content(/^MASQUERADE_DOMAIN_FILE/)
    }
  end

  context "with masquerade_domain_file => /foo/bar" do
    let(:params) do
      { :masquerade_domain_file => '/foo/bar' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-masquerade') \
              .with_content(/^MASQUERADE_DOMAIN_FILE\(`\/foo\/bar'\)dnl$/) \
              .without_content(/^MASQUERADE_DOMAIN\(/)
    }
  end
end
