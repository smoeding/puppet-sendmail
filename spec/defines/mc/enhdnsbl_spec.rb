require 'spec_helper'

describe 'sendmail::mc::enhdnsbl' do
  let(:title) { 'bl.example.com' }

  context 'with defaults' do
    it {
      should contain_concat__fragment('sendmail_mc-enhdnsbl_bl.example.com') \
              .with_content(/^FEATURE\(`enhdnsbl', `bl.example.com'\)dnl$/) \
              .with_order('51') \
              .that_notifies('Class[sendmail::makeall]')

      should contain_class('sendmail::mc::enhdnsbl_section')
   }
  end

  context 'with reject_message => foo' do
    let(:params) do
      { :reject_message => 'foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-enhdnsbl_bl.example.com') \
              .with_content(/`bl.example.com', `foo'\)dnl$/)
    }
  end

  context 'with allow_temporary_failure => true' do
    let(:params) do
      { :allow_temporary_failure => true }
    end

    it {
      should contain_concat__fragment('sendmail_mc-enhdnsbl_bl.example.com') \
              .with_content(/`bl.example.com', , `t'\)dnl$/)
    }
  end

  context 'with lookup_result => foo' do
    let(:params) do
      { :lookup_result => 'foo' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-enhdnsbl_bl.example.com') \
              .with_content(/`bl.example.com', , , `foo'\)dnl$/)
    }
  end
end
