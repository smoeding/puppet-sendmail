require 'spec_helper'

describe 'sendmail::trusted_users' do

  it { should contain_class('sendmail::trusted_users') }

  context 'with default parameter' do
    it {
      should contain_file('/etc/mail/trusted-users').with(
               'ensure'  => 'file',
               'owner'   => 'root',
               'group'   => 'smmsp',
               'mode'    => '0644',
               'content' => '',
             )
    }
  end

  context 'with string parameter type' do
    let(:params) do
      { :trusted_users => "root" }
    end

    it { expect { should compile }.to raise_error(/is not an Array/) }
  end

  context 'with empty parameter' do
    let(:params) do
      { :trusted_users => [] }
    end

    it {
      should contain_file('/etc/mail/trusted-users')
    }
  end

  context 'with single element array' do
    let(:params) do
      { :trusted_users => [ 'foo' ] }
    end

    it {
      should contain_file('/etc/mail/trusted-users').with(
               'content' => "foo\n",
             )
    }
  end

  context 'with multiple element array' do
    let(:params) do
      { :trusted_users => [ 'foo', 'bar', 'baz' ] }
    end

    it {
      should contain_file('/etc/mail/trusted-users').with(
               'content' => "bar\nbaz\nfoo\n",
             )
    }
  end
end
