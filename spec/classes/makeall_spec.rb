require 'spec_helper'

describe 'sendmail::makeall' do
  let(:title) { 'makeall' }

  let :facts do
    { :operatingsystem => 'Debian' }
  end

  it {
    should contain_exec('sendmail::makeall') \
            .that_requires('Class[sendmail::package]')
  }
end
