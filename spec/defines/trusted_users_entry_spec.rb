require 'spec_helper'

describe 'sendmail::trusted_users::entry' do
  let(:title) { 'fred' }

  context 'On Debian' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    it do
      should contain_augeas('/etc/mail/trusted-users-fred') \
              .that_requires('Class[sendmail::trusted_users::file]')
    end
  end
end
