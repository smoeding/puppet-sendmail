require 'spec_helper'

describe 'sendmail::local_host_names' do

  context 'with default parameter' do
    it {
      should contain_file('/etc/mail/local-host-names').with(
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
      { :local_host_names => "localhost" }
    end

    it { expect { should compile }.to raise_error(/is not an Array/) }
  end

  context 'with empty parameter' do
    let(:params) do
      { :local_host_names => [] }
    end

    it {
      should contain_file('/etc/mail/local-host-names')
    }
  end

  context 'with single element array' do
    let(:params) do
      { :local_host_names => [ 'foo' ] }
    end

    it {
      should contain_file('/etc/mail/local-host-names').with(
               'content' => "foo\n",
             )
    }
  end

  context 'with multiple element array' do
    let(:params) do
      { :local_host_names => [ 'foo', 'bar', 'baz' ] }
    end

    it {
      should contain_file('/etc/mail/local-host-names').with(
               'content' => "bar\nbaz\nfoo\n",
             )
    }
  end
end
