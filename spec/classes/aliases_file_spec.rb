require 'spec_helper'

describe 'sendmail::aliases::file' do

  it { should contain_class('sendmail::aliases::file') }

  context 'On Debian' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
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

  context 'On Debian with content => foo' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    let(:params) do
      { :content => 'foo' }
    end

    it {
      should contain_file('/etc/aliases').with(
               'ensure'  => 'file',
               'owner'   => 'root',
               'group'   => 'root',
               'mode'    => '0644',
               'content' => 'foo',
               'source'  => nil,
             ).that_notifies('Class[sendmail::aliases::newaliases]')
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
      should contain_file('/etc/aliases').with(
               'ensure'  => 'file',
               'owner'   => 'root',
               'group'   => 'root',
               'mode'    => '0644',
               'content' => nil,
               'source'  => 'foo',
             ).that_notifies('Class[sendmail::aliases::newaliases]')
    }
  end
end
