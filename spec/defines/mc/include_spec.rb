require 'spec_helper'

describe 'sendmail::mc::include' do

  context 'with include file' do
    let(:title) { '/foo' }

    it {
      should contain_concat__fragment('sendmail_mc-include-/foo') \
            .with_content(/^include\(`\/foo'\)dnl$/) \
            .with_order('59') \
            .that_notifies('Class[sendmail::makeall]')
    }
  end

  context 'with order => xx' do
    let(:title) { '/foo' }

    let(:params) do
      { :order => 'xx' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-include-/foo') \
            .with_content(/^include\(`\/foo'\)dnl$/) \
            .with_order('xx') \
            .that_notifies('Class[sendmail::makeall]')
    }
  end
end
