require 'spec_helper'

describe 'sendmail::relay_domains' do

  it { should contain_class('sendmail::relay_domains') }

  context 'with default parameter' do
    it {
      should contain_file('/etc/mail/relay-domains').with(
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
      { :relay_domains => "example.org" }
    end

    it { expect { should compile }.to raise_error(/is not an Array/) }
  end

  context 'with empty parameter' do
    let(:params) do
      { :relay_domains => [] }
    end

    it {
      should contain_file('/etc/mail/relay-domains')
    }
  end

  context 'with single element array' do
    let(:params) do
      { :relay_domains => [ 'foo' ] }
    end

    it {
      should contain_file('/etc/mail/relay-domains').with(
               'content' => "foo\n",
             )
    }
  end

  context 'with multiple element array' do
    let(:params) do
      { :relay_domains => [ 'foo', 'bar', 'baz' ] }
    end

    it {
      should contain_file('/etc/mail/relay-domains').with(
               'content' => "bar\nbaz\nfoo\n",
             )
    }
  end
end
