require 'spec_helper'

describe 'sendmail::mc::versionid' do
  let(:title) { 'versionid' }

  let(:params) do
    { :versionid => 'foobar' }
  end

  # :id and :osfamily facts are needed for concat module
  let(:facts) do
    {
      :id              => 'stm',
      :osfamily        => 'Debian',
      :operatingsystem => 'Debian',
      :concat_basedir  => '/tmp',
    }
  end

  it do
    should contain_concat__fragment('sendmail_mc-versionid') \
            .with_content(/^VERSIONID\(`foobar'\)dnl$/) \
            .with_order('10') \
            .that_notifies('Class[sendmail::makeall]')
  end
end
