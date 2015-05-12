require 'spec_helper'

describe 'sendmail::mc::versionid' do
  let(:title) { 'versionid' }

  let(:params) do
    { :versionid => 'foobar' }
  end

  it {
    should contain_concat__fragment('sendmail_mc-versionid') \
            .with_content(/^VERSIONID\(`foobar'\)dnl$/) \
            .with_order('01') \
            .that_notifies('Class[sendmail::makeall]')
  }
end
