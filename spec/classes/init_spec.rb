require 'spec_helper'

describe 'sendmail' do

  context 'On Debian with no package name specified' do
    let(:facts) do
      { :operatingsystem => 'Debian' }
    end

    it {
      should contain_class('sendmail')
      should contain_class('sendmail::package')
      should contain_class('sendmail::service') \
              .that_requires('Class[sendmail::package]')
    }
  end

  context 'On RedHat with no package name specified' do
    let(:facts) do
      { :operatingsystem => 'RedHat' }
    end

    it {
      should contain_class('sendmail')
      should contain_class('sendmail::package')
      should contain_class('sendmail::service') \
              .that_requires('Class[sendmail::package]')
    }
  end

  context 'On an unsupported operating system' do
    let(:facts) do
      { :operatingsystem => 'VAX/VMS' }
    end

    it {
      expect { should compile }.to raise_error(/Unsupported operatingsystem/)
    }
  end
end
