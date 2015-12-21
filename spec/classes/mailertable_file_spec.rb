require 'spec_helper'

describe 'sendmail::mailertable::file' do

  it { should contain_class('sendmail::mailertable::file') }

  context 'On Debian' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    it {
      should contain_file('/etc/mail/mailertable').with(
               'ensure'  => 'file',
               'owner'   => 'smmta',
               'group'   => 'smmsp',
               'mode'    => '0644',
               'content' => nil,
               'source'  => nil,
             ).that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'On Debian with content => foo' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :content => 'foo' }
    end

    it {
      should contain_file('/etc/mail/mailertable').with(
               'ensure'  => 'file',
               'owner'   => 'smmta',
               'group'   => 'smmsp',
               'mode'    => '0644',
               'content' => 'foo',
               'source'  => nil,
             ).that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'On Debian with source => foo' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :source => 'foo' }
    end

    it {
      should contain_file('/etc/mail/mailertable').with(
               'ensure'  => 'file',
               'owner'   => 'smmta',
               'group'   => 'smmsp',
               'mode'    => '0644',
               'content' => nil,
               'source'  => 'foo',
             ).that_notifies('Class[sendmail::makeall]')
    }
  end
end
