require 'spec_helper'

describe 'sendmail::relay_domains::entry' do
  let(:title) { 'example.org' }

  context 'On Debian' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    it {
      should contain_augeas('/etc/mail/relay-domains-example.org') \
              .that_requires('Class[sendmail::relay_domains::file]')
    }
  end
end
