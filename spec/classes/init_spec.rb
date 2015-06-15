require 'spec_helper'

describe 'sendmail' do

  context 'On Debian with defaults' do
    it {
      should contain_class('sendmail')
      should contain_class('sendmail::package') \
              .that_comes_before('Anchor[sendmail::config]')
      should contain_class('sendmail::local_host_names')
      should contain_class('sendmail::mc')
      should contain_class('sendmail::submit')
      should contain_class('sendmail::service') \
              .that_requires('Anchor[sendmail::config]')
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

  context 'On unsupported operating system' do
    let(:facts) do
      { :operatingsystem => 'VAX/VMS' }
    end

    it {
      expect { should compile }.to raise_error(/Unsupported operatingsystem/)
    }
  end
end
