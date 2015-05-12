require 'spec_helper'

describe 'sendmail::mc::feature' do
  let(:title) { 'foobar' }

  # :id and :osfamily facts are needed for concat module
  let(:facts) do
    {
      :id              => 'stm',
      :osfamily        => 'Debian',
      :operatingsystem => 'Debian',
      :concat_basedir  => '/tmp',
    }
  end

  context 'with no argument' do
    it {
      should contain_concat__fragment('sendmail_mc-feature-foobar') \
              .with_content(/^FEATURE\(`foobar'\)dnl$/) \
              .with_order('22') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with one argument' do
    let(:params) do
      { :args => [ 'foo' ] }
    end

    it {
      should contain_concat__fragment('sendmail_mc-feature-foobar') \
              .with_content(/^FEATURE\(`foobar', `foo'\)dnl$/) \
              .with_order('22') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with two arguments' do
    let(:params) do
      { :args => [ 'foo', 'bar' ] }
    end

    it {
      should contain_concat__fragment('sendmail_mc-feature-foobar') \
              .with_content(/^FEATURE\(`foobar', `foo', `bar'\)dnl$/) \
              .with_order('22') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with one argument and explicit feature_name' do
    let(:params) do
      { :args => [ 'foo' ], :feature_name => 'baz' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-feature-foobar') \
              .with_content(/^FEATURE\(`baz', `foo'\)dnl$/) \
              .with_order('22') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with one argument and use_quotes => true' do
    let(:params) do
      { :args => [ 'foo' ], :use_quotes => true }
    end

    it {
      should contain_concat__fragment('sendmail_mc-feature-foobar') \
              .with_content(/^FEATURE\(`foobar', `foo'\)dnl$/) \
              .with_order('22') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with one argument and use_quotes => false' do
    let(:params) do
      { :args => [ 'foo' ], :use_quotes => false }
    end

    it {
      should contain_concat__fragment('sendmail_mc-feature-foobar') \
              .with_content(/^FEATURE\(`foobar', foo\)dnl$/) \
              .with_order('22') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with one empty string as argument' do
    let(:params) do
      { :args => [ '' ] }
    end

    it {
      should contain_concat__fragment('sendmail_mc-feature-foobar') \
              .with_content(/^FEATURE\(`foobar', `'\)dnl$/) \
              .with_order('22') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end
end
