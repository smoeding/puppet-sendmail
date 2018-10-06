require 'spec_helper'

describe 'sendmail::mc::privacy_flags' do
  let(:pre_condition) { 'include sendmail::service' }

  on_supported_os.each do |os, facts|
    context "on #{os} with defaults" do
      let(:facts) { facts }

      it {
        is_expected.to contain_class('sendmail::mc::privacy_flags')
        is_expected.to contain_sendmail__mc__define('confPRIVACY_FLAGS') \
          .with_expansion('')
      }
    end

    ['authwarnings', 'goaway',
     'needexpnhelo', 'needmailhelo', 'needvrfyhelo',
     'noactualrecipient', 'nobodyreturn', 'noetrn', 'noexpn', 'noreceipts',
     'noverb', 'novrfy',
     'public',
     'restrictexpand', 'restrictmailq', 'restrictqrun'].each do |flag|
      context "on #{os} with #{flag} => true" do
        let(:facts) { facts }

        let(:params) do
          { flag.to_sym => true }
        end

        it {
          is_expected.to contain_sendmail__mc__define('confPRIVACY_FLAGS') \
            .with_expansion(flag)
        }
      end
    end
  end
end
