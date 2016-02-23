require 'spec_helper'

describe 'sendmail::mc::daemon_options' do
  let(:title) { 'MSA' }

  context 'with default arguments' do
    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-daemon_options-MSA') \
              .with_content(/^DAEMON_OPTIONS\(`Name=MSA'\)dnl$/) \
              .with_order('40') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  [ 'MTA', 'MSA-v4', 'MSA-v6' ].each do |title|
    context "with title #{title}" do
      let(:title) { title }

      it {
        should contain_class('sendmail::mc::macro_section')
        should contain_concat__fragment("sendmail_mc-daemon_options-#{title}") \
                .with_content(/^DAEMON_OPTIONS\(`Name=#{title}'\)dnl$/) \
                .with_order('40') \
                .that_notifies('Class[sendmail::makeall]')
      }
    end
  end

  context 'with daemon_name => MTA' do
    let(:params) do
      { :daemon_name => 'MTA' }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-daemon_options-MSA') \
              .with_content(/^DAEMON_OPTIONS\(`Name=MTA'\)dnl$/) \
              .with_order('40') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with argument family => inet' do
    let(:title) { 'MTA-v4' }

    let(:params) do
      { :family => 'inet' }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-daemon_options-MTA-v4') \
              .with_content(/^DAEMON_OPTIONS\(`Name=MTA-v4, Family=inet'\)dnl$/) \
              .with_order('40') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with argument family => inet6' do
    let(:title) { 'MTA-v6' }

    let(:params) do
      { :family => 'inet6' }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-daemon_options-MTA-v6') \
              .with_content(/^DAEMON_OPTIONS\(`Name=MTA-v6, Family=inet6'\)dnl$/) \
              .with_order('40') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with illegal argument family' do
    let(:params) do
      { :family => 'foobar' }
    end

    it {
      expect {
        should compile
      }.to raise_error(/does not match/)
    }
  end

  context 'with argument delivery_mode => background' do
    let(:params) do
      { :delivery_mode => 'background' }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-daemon_options-MSA') \
              .with_content(/^DAEMON_OPTIONS\(`Name=MSA, DeliveryMode=b'\)dnl$/) \
              .with_order('40') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with argument delivery_mode => b' do
    let(:params) do
      { :delivery_mode => 'b' }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-daemon_options-MSA') \
              .with_content(/^DAEMON_OPTIONS\(`Name=MSA, DeliveryMode=b'\)dnl$/) \
              .with_order('40') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with argument delivery_mode => deferred' do
    let(:params) do
      { :delivery_mode => 'deferred' }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-daemon_options-MSA') \
              .with_content(/^DAEMON_OPTIONS\(`Name=MSA, DeliveryMode=d'\)dnl$/) \
              .with_order('40') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with argument delivery_mode => d' do
    let(:params) do
      { :delivery_mode => 'd' }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-daemon_options-MSA') \
              .with_content(/^DAEMON_OPTIONS\(`Name=MSA, DeliveryMode=d'\)dnl$/) \
              .with_order('40') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with argument delivery_mode => interactive' do
    let(:params) do
      { :delivery_mode => 'interactive' }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-daemon_options-MSA') \
              .with_content(/^DAEMON_OPTIONS\(`Name=MSA, DeliveryMode=i'\)dnl$/) \
              .with_order('40') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with argument delivery_mode => i' do
    let(:params) do
      { :delivery_mode => 'i' }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-daemon_options-MSA') \
              .with_content(/^DAEMON_OPTIONS\(`Name=MSA, DeliveryMode=i'\)dnl$/) \
              .with_order('40') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with argument delivery_mode => queueonly' do
    let(:params) do
      { :delivery_mode => 'queueonly' }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-daemon_options-MSA') \
              .with_content(/^DAEMON_OPTIONS\(`Name=MSA, DeliveryMode=q'\)dnl$/) \
              .with_order('40') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with argument delivery_mode => q' do
    let(:params) do
      { :delivery_mode => 'q' }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-daemon_options-MSA') \
              .with_content(/^DAEMON_OPTIONS\(`Name=MSA, DeliveryMode=q'\)dnl$/) \
              .with_order('40') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with argument addr => localhost' do
    let(:params) do
      { :addr => 'localhost' }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-daemon_options-MSA') \
              .with_content(/^DAEMON_OPTIONS\(`Name=MSA, Addr=localhost'\)dnl$/) \
              .with_order('40') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with argument port => smtp' do
    let(:params) do
      { :port => 'smtp' }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-daemon_options-MSA') \
              .with_content(/^DAEMON_OPTIONS\(`Name=MSA, Port=smtp'\)dnl$/) \
              .with_order('40') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with argument port => 25' do
    let(:params) do
      { :port => '25' }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-daemon_options-MSA') \
              .with_content(/^DAEMON_OPTIONS\(`Name=MSA, Port=25'\)dnl$/) \
              .with_order('40') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with argument family => inet and port => 25' do
    let(:params) do
      { :family => 'inet', :port => '25' }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-daemon_options-MSA') \
              .with_content(/^DAEMON_OPTIONS\(`Name=MSA, Family=inet, Port=25'\)dnl$/) \
              .with_order('40') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with input_filter of type string' do
    let(:params) do
      { :input_filter => 'foo' }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-daemon_options-MSA') \
              .with_content(/^DAEMON_OPTIONS\(`Name=MSA, InputFilter=foo'\)dnl$/)
    }
  end

  context 'with input_filter of type array of 1 element' do
    let(:params) do
      { :input_filter => [ 'foo' ] }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-daemon_options-MSA') \
              .with_content(/^DAEMON_OPTIONS\(`Name=MSA, InputFilter=foo'\)dnl$/)
    }
  end

  context 'with input_filter of type array of 2 elements' do
    let(:params) do
      { :input_filter => [ 'foo', 'bar' ] }
    end

    it {
      should contain_class('sendmail::mc::macro_section')
      should contain_concat__fragment('sendmail_mc-daemon_options-MSA') \
              .with_content(/^DAEMON_OPTIONS\(`Name=MSA, InputFilter=foo;bar'\)dnl$/)
    }
  end
end
