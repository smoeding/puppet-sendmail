require 'spec_helper'

describe 'sendmail::mc::ostype' do
  let(:title) { 'foonly' }

  # :id and :osfamily facts are needed for concat module
  let(:facts) do
    {
      :id              => 'stm',
      :osfamily        => 'Debian',
      :operatingsystem => 'Debian',
      :concat_basedir  => '/tmp',
    }
  end

  it {
    should contain_concat__fragment('sendmail_mc-ostype-foonly') \
            .with_content(/^OSTYPE\(`foonly'\)dnl$/) \
            .with_order('05') \
            .that_notifies('Class[sendmail::makeall]')
  }
end
