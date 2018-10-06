require 'spec_helper'

describe 'sendmail::mc::timeouts' do
  let(:pre_condition) { 'include sendmail::service' }

  on_supported_os.each do |os, facts|
    context "on #{os} with no parameter" do
      let(:facts) { facts }

      it {
        is_expected.to contain_class('sendmail::mc::timeouts')
        is_expected.not_to contain_concat__fragment('sendmail_mc-timeouts')
      }
    end

    context "on #{os} with one parameter" do
      let(:facts) { facts }

      let(:params) do
        { starttls: '1w3d5h7m9s' }
      end

      it {
        is_expected.to contain_concat__fragment('sendmail_mc-timeouts') \
          .without_content(%r{^define\(`confTO_A}) \
      }
    end

    ['aconnect', 'auth', 'command', 'connect', 'control', 'datablock',
     'datafinal', 'datainit', 'fileopen', 'helo', 'hoststatus', 'iconnect',
     'ident', 'initial', 'lhlo', 'mail', 'misc', 'quit', 'rcpt', 'rset',
     'starttls'].each do |param|

      context "on #{os} with parameter #{param}" do
        let(:facts) { facts }

        let(:params) do
          { param.to_sym => '1w3d5h7m9s' }
        end

        it {
          macro = 'confTO_' << param.upcase

          is_expected.to contain_concat__fragment('sendmail_mc-timeouts') \
            .with_content(%r{^define\(`#{macro}', `1w3d5h7m9s'\)dnl$}) \
            .with_order('16')
        }
      end
    end
  end
end
