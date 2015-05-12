require 'spec_helper'

describe 'sendmail::mc::local_config' do
  let(:title) { 'local_config' }

  # :id and :osfamily facts are needed for concat module
  let(:facts) do
    {
      :id              => 'stm',
      :osfamily        => 'Debian',
      :operatingsystem => 'Debian',
      :concat_basedir  => '/tmp',
    }
  end

  context 'without source or content' do
    it {
      expect { subject.call }.to raise_error(Puppet::Error, /needs either of/)
    }
  end


  context 'local_config with source only' do
    let(:params) do
      { :source => 'foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-local_config') \
              .with_source('foo') \
              .with_order('99') \
              .that_notifies('Class[sendmail::makeall]')

      should contain_class('sendmail::mc::local_config_section')
    }
  end

  context 'local_config with content only' do
    let(:params) do
      { :content => 'foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-local_config') \
              .with_content('foo') \
              .with_order('99') \
              .that_notifies('Class[sendmail::makeall]')

      should contain_class('sendmail::mc::local_config_section')
    }
  end

  context 'local_config with source and content' do
    let(:params) do
      { :source => 'foo', :content => 'foo' }
    end

    it {
      expect { subject.call }.to raise_error(Puppet::Error, /cannot have both/)
    }
  end
end
