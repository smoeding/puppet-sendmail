require 'spec_helper'

describe 'sendmail::local_host_names::entry' do
  let(:title) { 'localhost' }

  context 'On Debian' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    it do
      should contain_augeas('/etc/mail/local-host-names-localhost') \
              .that_requires('Class[sendmail::local_host_names::file]')
    end
  end
end
