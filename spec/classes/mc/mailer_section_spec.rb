require 'spec_helper'

describe 'sendmail::mc::mailer_section' do

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
      should contain_concat__fragment('sendmail_mc-mailer_header') \
              .with_content(/^dnl # Mailer$/) \
              .with_order('80') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end
end
