require 'spec_helper'

describe 'sendmail::mc::local_config' do
  let(:title) { 'local_config' }

  context 'without source or content' do
    it {
      expect { subject.call }.to raise_error(Puppet::Error, /needs either of/)
    }
  end


  context 'with source only' do
    let(:params) do
      { :source => 'foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-local_config-local_config') \
              .with_source('foo') \
              .with_order('81') \
              .that_notifies('Class[sendmail::makeall]')

      should contain_class('sendmail::mc::local_config_section')
    }
  end

  context 'with content only' do
    let(:params) do
      { :content => 'foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-local_config-local_config') \
              .with_content('foo') \
              .with_order('81') \
              .that_notifies('Class[sendmail::makeall]')

      should contain_class('sendmail::mc::local_config_section')
    }
  end

  context 'with source and content' do
    let(:params) do
      { :source => 'foo', :content => 'foo' }
    end

    it {
      expect { subject.call }.to raise_error(Puppet::Error, /cannot have both/)
    }
  end

  context 'for CipherList' do
    let(:title) { 'CipherList' }

    let(:params) do
      { :content => 'foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-local_config-CipherList') \
              .with_content('foo') \
              .with_order('81') \
              .that_notifies('Class[sendmail::makeall]')

      should contain_class('sendmail::mc::local_config_section')
    }
  end

  context 'for ClientSSLOptions' do
    let(:title) { 'ClientSSLOptions' }

    let(:params) do
      { :content => 'foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-local_config-ClientSSLOptions') \
              .with_content('foo') \
              .with_order('81') \
              .that_notifies('Class[sendmail::makeall]')

      should contain_class('sendmail::mc::local_config_section')
    }
  end

  context 'for ServerSSLOptions' do
    let(:title) { 'ServerSSLOptions' }

    let(:params) do
      { :content => 'foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-local_config-ServerSSLOptions') \
              .with_content('foo') \
              .with_order('81') \
              .that_notifies('Class[sendmail::makeall]')

      should contain_class('sendmail::mc::local_config_section')
    }
  end
end
