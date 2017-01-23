require 'spec_helper'

describe 'sendmail::mc::milter' do

  let(:title) { 'greylist' }

  let(:params) do
    {
      :socket_type => 'local',
      :socket_spec => '/old/sock',
    }
  end

  context 'with socket_type and socket_spec' do
    it {
      should contain_concat__fragment('sendmail_mc-milter-greylist') \
              .with_content("INPUT_MAIL_FILTER(`greylist', `S=local:/old/sock, F=T')dnl\n") \
              .with_order('56-00') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::milter_section')
    }
  end

  context 'with order => 01' do
    let(:params) do
      super().merge(
        {
          :order => '01',
        }
      )
    end

    it {
      should contain_concat__fragment('sendmail_mc-milter-greylist') \
              .with_content("INPUT_MAIL_FILTER(`greylist', `S=local:/old/sock, F=T')dnl\n") \
              .with_order('56-01') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::milter_section')
    }
  end

  context 'with send_timeout' do
    let(:params) do
      super().merge(
        {
          :send_timeout => '2m',
        }
      )
    end

    it {
      should contain_concat__fragment('sendmail_mc-milter-greylist') \
              .with_content("INPUT_MAIL_FILTER(`greylist', `S=local:/old/sock, F=T, T=S:2m')dnl\n") \
              .with_order('56-00') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::milter_section')
    }
  end

  context 'with receive_timeout' do
    let(:params) do
      super().merge(
        {
          :receive_timeout => '3m',
        }
      )
    end

    it {
      should contain_concat__fragment('sendmail_mc-milter-greylist') \
              .with_content("INPUT_MAIL_FILTER(`greylist', `S=local:/old/sock, F=T, T=R:3m')dnl\n") \
              .with_order('56-00') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::milter_section')
    }
  end

  context 'with eom_timeout' do
    let(:params) do
      super().merge(
        {
          :eom_timeout => '5m',
        }
      )
    end

    it {
      should contain_concat__fragment('sendmail_mc-milter-greylist') \
              .with_content("INPUT_MAIL_FILTER(`greylist', `S=local:/old/sock, F=T, T=E:5m')dnl\n") \
              .with_order('56-00') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::milter_section')
    }
  end

  context 'with connect_timeout' do
    let(:params) do
      super().merge(
        {
          :connect_timeout => '7m',
        }
      )
    end

    it {
      should contain_concat__fragment('sendmail_mc-milter-greylist') \
              .with_content("INPUT_MAIL_FILTER(`greylist', `S=local:/old/sock, F=T, T=C:7m')dnl\n") \
              .with_order('56-00') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::milter_section')
    }
  end

  context 'with all timeouts' do
    let(:params) do
      super().merge(
        {
          :send_timeout    => '2m',
          :receive_timeout => '3m',
          :eom_timeout     => '5m',
          :connect_timeout => '7m',
        }
      )
    end

    it {
      should contain_concat__fragment('sendmail_mc-milter-greylist') \
              .with_content("INPUT_MAIL_FILTER(`greylist', `S=local:/old/sock, F=T, T=S:2m;R:3m;E:5m;C:7m')dnl\n") \
              .with_order('56-00') \
              .that_notifies('Class[sendmail::makeall]')
      should contain_class('sendmail::mc::milter_section')
    }
  end

  [ 'R', 'T', '4', '' ].each do |flag|
    context "with flags => #{flag}" do
      let(:params) do
        super().merge(
          {
            :flags => flag,
          }
        )
      end

      it {
        should contain_concat__fragment('sendmail_mc-milter-greylist') \
                 .with_content("INPUT_MAIL_FILTER(`greylist', `S=local:/old/sock, F=#{flag}')dnl\n") \
                 .with_order('56-00') \
                 .that_notifies('Class[sendmail::makeall]')
        should contain_class('sendmail::mc::milter_section')
      }
    end
  end
end
