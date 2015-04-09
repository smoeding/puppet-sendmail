require 'spec_helper'

describe 'sendmail::relaydomains::entry' do
  let(:title) { 'example.org' }

  context 'On Debian' do
    let(:facts) do
      { 'osfamily' => 'Debian' }
    end

    it do
      should contain_augeas('/etc/mail/relay-domains-example.org') \
              .that_requires('Class[sendmail::relaydomains::file]')
    end
  end
end
