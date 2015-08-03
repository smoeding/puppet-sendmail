require 'spec_helper'

describe 'sendmail::mc::versionid' do
  let(:title) { 'foo' }

  context 'with title only' do
    it {
      should contain_concat__fragment('sendmail_mc-versionid') \
              .with_content(/^VERSIONID\(`foo'\)dnl$/) \
              .with_order('01') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with versionid => foo' do
    let(:params) do
      { :versionid => 'bar' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-versionid') \
              .with_content(/^VERSIONID\(`bar'\)dnl$/) \
              .with_order('01') \
              .that_notifies('Class[sendmail::makeall]')
    }
  end
end
