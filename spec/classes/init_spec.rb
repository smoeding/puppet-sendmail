require 'spec_helper'

describe 'sendmail' do

  [ 'Debian', 'Redhat' ].each do |operatingsystem|
    context 'On #{operatingsystem} with defaults' do
      let(:facts) do
        { :operatingsystem => operatingsystem }
      end

      it {
        should contain_class('sendmail')
        should contain_class('sendmail::package')
        should contain_class('sendmail::service') \
                .that_requires('Class[sendmail::package]')
      }
    end
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
