require 'spec_helper'
describe 'sendmail' do

  context 'with defaults for all parameters' do
    it { should contain_class('sendmail') }
  end
end
