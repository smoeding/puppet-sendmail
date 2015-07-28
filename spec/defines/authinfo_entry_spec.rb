require 'spec_helper'

describe 'sendmail::authinfo::entry' do
  let(:title) { 'example.com' }

  let(:params) do
    { :value => 'REJECT' }
  end

  it {
    should contain_class('sendmail::params')
    should contain_class('sendmail::makeall')
    should contain_class('sendmail::authinfo::file')
    should contain_augeas('/etc/mail/authinfo-example.com') \
            .that_requires('Class[sendmail::authinfo::file]') \
            .that_notifies('Class[sendmail::makeall]')
  }

  context 'Missing value' do
    let(:params) do
      { :ensure => 'present' }
    end

    it {
      expect {
        should compile
      }.to raise_error(/value must be set when creating an authinfo entry/)
    }
  end
end
