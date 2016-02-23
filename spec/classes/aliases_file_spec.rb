require 'spec_helper'

describe 'sendmail::aliases::file' do

  it { should contain_class('sendmail::aliases::file') }

  context 'On Debian' do
    let(:facts) do
      { :operatingsystem => 'Debian', :osfamily => 'Debian' }
    end

    it {
      should contain_file('/etc/aliases').with(
               'ensure'  => 'file',
               'owner'   => 'root',
               'group'   => 'root',
               'mode'    => '0644',
               'content' => nil,
               'source'  => nil,
             ).that_notifies('Class[sendmail::aliases::newaliases]')
    }
  end

  context 'On RedHat' do
    let(:facts) do
      { :operatingsystem => 'RedHat', :osfamily => 'RedHat' }
    end

    it {
      should contain_file('/etc/aliases').with(
               'ensure'  => 'file',
               'owner'   => 'root',
               'group'   => 'root',
               'mode'    => '0644',
               'content' => nil,
               'source'  => nil,
             ).that_notifies('Class[sendmail::aliases::newaliases]')
    }
  end

  context 'with content => foo' do
    let(:params) do
      { :content => 'foo' }
    end

    it {
      should contain_file('/etc/aliases').with(
               'ensure'  => 'file',
               'content' => 'foo',
               'source'  => nil,
             ).that_notifies('Class[sendmail::aliases::newaliases]')
    }
  end

  context 'with source => foo' do
    let(:params) do
      { :source => 'foo' }
    end

    it {
      should contain_file('/etc/aliases').with(
               'ensure'  => 'file',
               'content' => nil,
               'source'  => 'foo',
             ).that_notifies('Class[sendmail::aliases::newaliases]')
    }
  end
end
