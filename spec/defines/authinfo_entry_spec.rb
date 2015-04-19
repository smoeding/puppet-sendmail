require 'spec_helper'

describe 'sendmail::authinfo::entry' do
  let(:title) { 'example.com' }

  let(:params) do
    { :value => 'REJECT' }
  end

  let(:facts) do
    { :operatingsystem => 'Debian' }
  end

  it do
    should contain_augeas('/etc/mail/authinfo-example.com') \
            .that_requires('Class[sendmail::authinfo::file]') \
            .that_notifies('Class[sendmail::makeall]')
  end

  context 'Missing value' do
    let(:params) { { :ensure => 'present' } }

    it do
      expect {
        should compile
      }.to raise_error(/value must be set when creating an authinfo entry/)
    end
  end
end
