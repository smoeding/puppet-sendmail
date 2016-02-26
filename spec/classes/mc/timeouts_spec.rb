require 'spec_helper'

describe 'sendmail::mc::timeouts' do

  it { should contain_class('sendmail::mc::timeouts') }

  context "with no parameter" do
    it {
      should_not contain_concat__fragment('sendmail_mc-timeouts')
    }
  end

  context "with one parameter" do
    let(:params) do
      { :starttls => '1w3d5h7m9s' }
    end

    it {
      should contain_concat__fragment('sendmail_mc-timeouts') \
                .without_content(/^define\(`confTO_A/) \
    }
  end

  [ 'aconnect', 'auth', 'command', 'connect', 'control', 'datablock',
    'datafinal', 'datainit', 'fileopen', 'helo', 'hoststatus', 'iconnect',
    'ident', 'initial', 'lhlo', 'mail', 'misc', 'quit', 'rcpt', 'rset',
    'starttls' ].each do |param|

    context "with parameter #{param}" do
      let(:params) do
        { param.to_sym => '1w3d5h7m9s' }
      end

      it {
        macro = "confTO_" << param.upcase

        should contain_concat__fragment('sendmail_mc-timeouts') \
                .with_content(/^define\(`#{macro}', `1w3d5h7m9s'\)dnl$/) \
                .with_order('16')
      }
    end
  end
end
