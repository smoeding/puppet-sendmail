require 'spec_helper'

describe 'sendmail::mc::milter' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }
    let(:title) { 'greylist' }

    let(:params) do
      { socket_type: 'local', socket_spec: '/old/sock' }
    end

    context "on #{os} with socket_type and socket_spec" do
      it {
        is_expected.to contain_class('sendmail::mc::milter_section')

        is_expected.to contain_concat__fragment('sendmail_mc-milter-greylist')
          .with_content("INPUT_MAIL_FILTER(`greylist', `S=local:/old/sock, F=T')dnl\n")
          .with_order('56-00')
      }
    end

    context "on #{os} with enable => true" do
      let(:params) do
        super().merge(enable: true)
      end

      it {
        is_expected.to contain_class('sendmail::mc::milter_section')

        is_expected.to contain_concat__fragment('sendmail_mc-milter-greylist')
          .with_content("INPUT_MAIL_FILTER(`greylist', `S=local:/old/sock, F=T')dnl\n")
          .with_order('56-00')
      }
    end

    context "on #{os} with enable => false" do
      let(:params) do
        super().merge(enable: false)
      end

      it {
        is_expected.to contain_class('sendmail::mc::milter_section')

        is_expected.to contain_concat__fragment('sendmail_mc-milter-greylist')
          .with_content("MAIL_FILTER(`greylist', `S=local:/old/sock, F=T')dnl\n")
          .with_order('56-00')
      }
    end

    context "on #{os} with order => 01" do
      let(:params) do
        super().merge(order: '01')
      end

      it {
        is_expected.to contain_class('sendmail::mc::milter_section')

        is_expected.to contain_concat__fragment('sendmail_mc-milter-greylist')
          .with_content("INPUT_MAIL_FILTER(`greylist', `S=local:/old/sock, F=T')dnl\n")
          .with_order('56-01')
      }
    end

    context "on #{os} with send_timeout" do
      let(:params) do
        super().merge(send_timeout: '2m')
      end

      it {
        is_expected.to contain_class('sendmail::mc::milter_section')

        is_expected.to contain_concat__fragment('sendmail_mc-milter-greylist')
          .with_content("INPUT_MAIL_FILTER(`greylist', `S=local:/old/sock, F=T, T=S:2m')dnl\n")
          .with_order('56-00')
      }
    end

    context "on #{os} with receive_timeout" do
      let(:params) do
        super().merge(receive_timeout: '3m')
      end

      it {
        is_expected.to contain_class('sendmail::mc::milter_section')

        is_expected.to contain_concat__fragment('sendmail_mc-milter-greylist')
          .with_content("INPUT_MAIL_FILTER(`greylist', `S=local:/old/sock, F=T, T=R:3m')dnl\n")
          .with_order('56-00')
      }
    end

    context "on #{os} with eom_timeout" do
      let(:params) do
        super().merge(eom_timeout: '5m')
      end

      it {
        is_expected.to contain_class('sendmail::mc::milter_section')

        is_expected.to contain_concat__fragment('sendmail_mc-milter-greylist')
          .with_content("INPUT_MAIL_FILTER(`greylist', `S=local:/old/sock, F=T, T=E:5m')dnl\n")
          .with_order('56-00')
      }
    end

    context "on #{os} with connect_timeout" do
      let(:params) do
        super().merge(connect_timeout: '7m')
      end

      it {
        is_expected.to contain_class('sendmail::mc::milter_section')

        is_expected.to contain_concat__fragment('sendmail_mc-milter-greylist')
          .with_content("INPUT_MAIL_FILTER(`greylist', `S=local:/old/sock, F=T, T=C:7m')dnl\n")
          .with_order('56-00')
      }
    end

    context "on #{os} with all timeouts" do
      let(:params) do
        super().merge(
          send_timeout:    '2m',
          receive_timeout: '3m',
          eom_timeout:     '5m',
          connect_timeout: '7m',
        )
      end

      it {
        is_expected.to contain_class('sendmail::mc::milter_section')

        is_expected.to contain_concat__fragment('sendmail_mc-milter-greylist')
          .with_content("INPUT_MAIL_FILTER(`greylist', `S=local:/old/sock, F=T, T=S:2m;R:3m;E:5m;C:7m')dnl\n")
          .with_order('56-00')
      }
    end

    ['R', 'T', '4', ''].each do |flag|
      context "on #{os} with flags => #{flag}" do
        let(:params) do
          super().merge(flags: flag)
        end

        it {
          is_expected.to contain_class('sendmail::mc::milter_section')

          is_expected.to contain_concat__fragment('sendmail_mc-milter-greylist')
            .with_content("INPUT_MAIL_FILTER(`greylist', `S=local:/old/sock, F=#{flag}')dnl\n")
            .with_order('56-00')
        }
      end
    end
  end
end
