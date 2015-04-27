require 'spec_helper'

describe 'sendmail::mc::domain' do
  let(:title) { 'foo' }

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
    should contain_concat__fragment('sendmail_mc-domain-foo') \
            .with_content(/^DOMAIN\(`foo'\)dnl$/) \
            .with_order('07') \
            .that_notifies('Class[sendmail::makeall]')
  }
end
