require 'spec_helper'

describe 'sendmail' do

  context 'On Debian with defaults' do
    it {
      should contain_anchor('sendmail::begin')
      should contain_anchor('sendmail::config')
      should contain_anchor('sendmail::end')

      should contain_class('sendmail')
      should contain_class('sendmail::params')

      should contain_class('sendmail::package') \
              .that_requires('Anchor[sendmail::begin]') \
              .that_comes_before('Anchor[sendmail::config]')

      should contain_class('sendmail::local_host_names')
      should contain_class('sendmail::relay_domains')
      should contain_class('sendmail::trusted_users')
      should contain_class('sendmail::access')
      should contain_class('sendmail::mc')
      should contain_class('sendmail::submit')

      should contain_class('sendmail::service') \
              .that_requires('Anchor[sendmail::config]') \
              .that_comes_before('Anchor[sendmail::end]')

      should_not contain_sendmail__mc__starttls('starttls')
    }
  end

  context 'On Debian with enable_access_db => false' do
    let(:params) do
      { :enable_access_db => false }
    end

    it {
      should_not contain_class('sendmail::access')
    }
  end

  context 'On Debian with local_host_names => www.example.net' do
    let(:params) do
      { :local_host_names => [ 'www.example.net' ] }
    end

    it {
      should contain_class('sendmail::local_host_names').with(
               'local_host_names' => [ 'www.example.net' ],
             )
    }
  end

  context 'On Debian with relay_domains => example.net' do
    let(:params) do
      { :relay_domains => [ 'example.net' ] }
    end

    it {
      should contain_class('sendmail::relay_domains').with(
               'relay_domains' => [ 'example.net' ],
             )
    }
  end

  context 'On Debian with trusted_users => fred' do
    let(:params) do
      { :trusted_users => [ 'fred' ] }
    end

    it {
      should contain_class('sendmail::trusted_users').with(
               'trusted_users' => [ 'fred' ],
             )
    }
  end

  context 'On Debian with manage_sendmail_mc => true' do
    let(:params) do
      { :manage_sendmail_mc => true }
    end

    it {
      should contain_class('sendmail::mc') \
              .that_comes_before('Anchor[sendmail::config]') \
              .that_requires('Class[sendmail::package]') \
              .that_notifies('Class[sendmail::service]')
    }
  end

  context 'On Debian with manage_sendmail_mc => false' do
    let(:params) do
      { :manage_sendmail_mc => false }
    end

    it {
      should_not contain_class('sendmail::mc')
      should_not contain_sendmail__mc__starttls('starttls')
    }
  end

  context 'On Debian with manage_submit_mc => true' do
    let(:params) do
      { :manage_submit_mc => true }
    end

    it {
      should contain_class('sendmail::submit') \
              .that_comes_before('Anchor[sendmail::config]') \
              .that_requires('Class[sendmail::package]') \
              .that_notifies('Class[sendmail::service]')
    }
  end

  context 'On Debian with manage_submit_mc => false' do
    let(:params) do
      { :manage_submit_mc => false }
    end

    it {
      should_not contain_class('sendmail::submit')
    }
  end

  context 'On Debian with cipher_list defined' do
    let(:params) do
      { :manage_sendmail_mc => true, :cipher_list => 'foo' }
    end

    it {
      should contain_sendmail__mc__starttls('starttls').with(
               'cipher_list' => 'foo',
             )
    }
  end

  context 'On unsupported operating system' do
    let(:facts) do
      { :operatingsystem => 'VAX/VMS' }
    end

    it {
      expect { should compile }.to raise_error(/Unsupported operatingsystem/)
    }
  end
end
