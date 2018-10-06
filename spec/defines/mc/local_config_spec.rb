require 'spec_helper'

describe 'sendmail::mc::local_config' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    let(:title) { 'local_config' }
    let(:pre_condition) { 'include sendmail::service' }

    context "on #{os} without source or content" do
      it {
        is_expected.to compile.and_raise_error(%r{needs either of})
      }
    end

    context "on #{os} with source only" do
      let(:params) do
        { source: 'foo' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::local_config_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-local_config-local_config') \
          .with_source('foo') \
          .with_order('81') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with content only" do
      let(:params) do
        { content: 'foo' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::local_config_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-local_config-local_config') \
          .with_content('foo') \
          .with_order('81') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} with source and content" do
      let(:params) do
        { source: 'foo', content: 'foo' }
      end

      it {
        is_expected.to compile.and_raise_error(%r{cannot have both})
      }
    end

    context "on #{os} for CipherList" do
      let(:title) { 'CipherList' }

      let(:params) do
        { content: 'foo' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::local_config_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-local_config-CipherList') \
          .with_content('foo') \
          .with_order('81') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} for ClientSSLOptions" do
      let(:title) { 'ClientSSLOptions' }

      let(:params) do
        { content: 'foo' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::local_config_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-local_config-ClientSSLOptions') \
          .with_content('foo') \
          .with_order('81') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end

    context "on #{os} for ServerSSLOptions" do
      let(:title) { 'ServerSSLOptions' }

      let(:params) do
        { content: 'foo' }
      end

      it {
        is_expected.to contain_class('sendmail::mc::local_config_section')
        is_expected.to contain_class('sendmail::makeall')

        is_expected.to contain_concat__fragment('sendmail_mc-local_config-ServerSSLOptions') \
          .with_content('foo') \
          .with_order('81') \
          .that_notifies('Class[sendmail::makeall]')
      }
    end
  end
end
