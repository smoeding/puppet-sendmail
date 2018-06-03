require 'spec_helper'

describe 'sendmail::mc::generics_domain' do
  let(:pre_condition) {
    'include sendmail::service'
  }

  context 'with domain example.net' do
    let(:title) { 'example.net' }

    it {
      should contain_class('sendmail::makeall')

      should contain_concat__fragment('sendmail_mc-generics_domain-example.net') \
              .with_content(/^GENERICS_DOMAIN\(`example.net'\)dnl$/) \
              .with_order('32') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end
end
