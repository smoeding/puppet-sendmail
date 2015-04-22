require 'spec_helper'

describe 'sendmail::makeall' do

  [ 'Debian', 'RedHat' ].each do |operatingsystem|
    context "On #{operatingsystem}" do
      let(:facts) do
        { :operatingsystem => operatingsystem }
      end

      it {
        should contain_exec('sendmail::makeall') \
                .that_requires('Class[sendmail::package]')
      }
    end
  end
end
