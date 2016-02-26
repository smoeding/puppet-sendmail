require 'spec_helper'

describe 'sendmail::mc::privacy_flags' do

  context 'with defaults' do
    it {
      should contain_class('sendmail::mc::privacy_flags')
      should contain_sendmail__mc__define('confPRIVACY_FLAGS') \
              .with_expansion('')
    }
  end

  [ 'authwarnings', 'goaway',
    'needexpnhelo', 'needmailhelo', 'needvrfyhelo',
    'noactualrecipient', 'nobodyreturn', 'noetrn', 'noexpn', 'noreceipts',
    'noverb', 'novrfy',
    'public',
    'restrictexpand', 'restrictmailq', 'restrictqrun',
  ].each do |flag|
    context "with #{flag} => true" do
      let(:params) do
        { flag.to_sym => true }
      end

      it {
        should contain_sendmail__mc__define('confPRIVACY_FLAGS') \
                .with_expansion(flag)
      }
    end
  end
end
