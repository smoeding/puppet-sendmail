require 'spec_helper'

describe 'sendmail::trustedusers::entry' do
  let(:title) { 'fred' }

  context 'On Debian' do
    let(:facts) do
      { 'osfamily' => 'Debian' }
    end

    it do
      should contain_augeas('/etc/mail/trusted-users-fred') \
              .that_requires('Class[sendmail::trustedusers::file]')
    end
  end
end
