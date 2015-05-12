require 'spec_helper'

describe 'sendmail::mc::macro_section' do

  # :id and :osfamily facts are needed for concat module
  let(:facts) do
    {
      :id              => 'stm',
      :osfamily        => 'Debian',
      :operatingsystem => 'Debian',
      :concat_basedir  => '/tmp',
    }
  end

  context 'with no arguments' do
    it {
      should contain_concat__fragment('sendmail_mc-macro_header') \
              .with_content(/^dnl # Macros$/) \
              .with_order('30') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end
end
