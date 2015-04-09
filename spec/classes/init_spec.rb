require 'spec_helper'

describe 'sendmail' do

  context 'On Debian with no package name specified' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    it { should contain_class('sendmail') }
  end

  context 'On RedHat with no package name specified' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    it { should contain_class('sendmail') }
  end
end
