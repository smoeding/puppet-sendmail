require 'spec_helper'

describe 'sendmail::access::entry' do
  let(:title) { 'example.com' }

  let(:params) do
    { :value => 'REJECT' }
  end

  let(:facts) do
    { 'operatingsystem' => 'Debian' }
  end

  it do
    should contain_augeas('/etc/mail/access-example.com') \
            .that_requires('Class[sendmail::access::file]')
  end

  context 'Missing value' do
    let(:params) { { :ensure => 'present' } }

    it do
      expect {
        should compile
      }.to raise_error(/value must be set when creating an access entry/)
    end
  end
end
