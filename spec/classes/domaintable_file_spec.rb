require 'spec_helper'

describe 'sendmail::domaintable::file' do

  it { should contain_class('sendmail::domaintable::file') }

  context 'On Debian' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    it {
      should contain_file('/etc/mail/domaintable').with(
               'ensure' => 'file',
               'owner'  => 'smmta',
               'group'  => 'smmsp',
               'mode'   => '0640',
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
      should contain_file('/etc/mail/domaintable').with(
               'ensure' => 'file',
               'owner'  => 'smmta',
               'group'  => 'smmsp',
               'mode'   => '0640',
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
      should contain_file('/etc/mail/domaintable').with(
               'ensure' => 'file',
               'owner'  => 'smmta',
               'group'  => 'smmsp',
               'mode'   => '0640',
               'content' => nil,
               'source'  => 'foo',
             ).that_notifies('Class[sendmail::makeall]')
    }
  end
end
