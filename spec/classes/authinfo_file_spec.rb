require 'spec_helper'

describe 'sendmail::authinfo::file' do

  it { should contain_class('sendmail::authinfo::file') }

  context 'On Debian' do
    let(:facts) do
      { :operatingsystem => 'Debian', :osfamily => 'Debian' }
    end

    it {
      should contain_file('/etc/mail/authinfo').with(
               'ensure' => 'file',
               'owner'  => 'root',
               'group'  => 'smmsp',
               'mode'   => '0600',
               'content' => nil,
               'source'  => nil,
             ).that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'On RedHat' do
    let(:facts) do
      { :operatingsystem => 'RedHat', :osfamily => 'RedHat' }
    end

    it {
      should contain_file('/etc/mail/authinfo').with(
               'ensure'  => 'file',
               'owner'   => 'root',
               'group'   => 'smmsp',
               'mode'    => '0600',
               'content' => nil,
               'source'  => nil,
             ).that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with content => foo' do
    let(:params) do
      { :content => 'foo' }
    end

    it {
      should contain_file('/etc/mail/authinfo').with(
               'ensure'  => 'file',
               'content' => 'foo',
               'source'  => nil,
             ).that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with source => foo' do
    let(:params) do
      { :source => 'foo' }
    end

    it {
      should contain_file('/etc/mail/authinfo').with(
               'ensure'  => 'file',
               'content' => nil,
               'source'  => 'foo',
             ).that_notifies('Class[sendmail::makeall]')
    }
  end
end
