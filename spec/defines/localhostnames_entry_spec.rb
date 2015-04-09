require 'spec_helper'

describe 'sendmail::localhostnames::entry' do
  let(:title) { 'localhost' }

  context 'On Debian' do
    let(:facts) do
      { 'osfamily' => 'Debian' }
    end

    it do
      should contain_augeas('/etc/mail/local-host-names-localhost') \
              .that_requires('Class[sendmail::localhostnames::file]')
    end
  end
end
