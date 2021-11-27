require 'spec_helper'

describe 'sendmail::mc::virtuser_domain' do
  context 'with domain example.net' do
    let(:title) { 'example.net' }

    it {
      is_expected.to contain_concat__fragment('sendmail_mc-virtuser_domain-example.net') \
        .with_content(%r{^VIRTUSER_DOMAIN\(`example.net'\)dnl$}) \
        .with_order('37')
      is_expected.to contain_class('sendmail::mc::macro_section')
    }
  end
end
