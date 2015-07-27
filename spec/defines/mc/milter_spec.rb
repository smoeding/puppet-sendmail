require 'spec_helper'

describe 'sendmail::mc::milter' do

  let(:title) { 'greylist' }

  let(:params) do
    {
      :socket_type => 'local',
      :socket_spec => '/var/run/milter-greylist/milter-greylist.sock',
    }
  end

  context 'with socket_type and socket_spec' do

    it {
      should contain_concat__fragment('sendmail_mc-milter-greylist') \
              .with_content("INPUT_MAIL_FILTER(`greylist', `S=local:/var/run/milter-greylist/milter-greylist.sock, F=T')dnl\n") \
              .with_order('56-00') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::milter_section')
    }
  end
end
