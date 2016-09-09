require 'spec_helper'

describe Facter::Util::Fact do
  before {
    Facter.clear
  }

  describe 'sendmail_version' do
    command = 'sendmail -d0.4 -ODontProbeInterfaces=true -bv root 2>/dev/null'
    options = { :on_fail => nil, :timeout => 10 }

    context 'with value' do
      output = <<-END
Version 8.14.4
 Compiled with: DNSMAP LDAPMAP LDAP_REFERRALS LOG MAP_REGEX MATCHGECOS
                MILTER MIME7TO8 MIME8TO7 NAMED_BIND NETINET NETINET6 NETUNIX
                NEWDB NIS NISPLUS PIPELINING SASLv2 SCANF SOCKETMAP STARTTLS
                TCPWRAPPERS USERDB USE_LDAP_INIT XDEBUG
Canonical name: mail.example.net
 UUCP nodename: mail
        a.k.a.: mail
        a.k.a.: [10.11.12.13]

============ SYSTEM IDENTITY (after readcf) ============
      (short domain name) $w = mail
  (canonical domain name) $j = mail.example.net
         (subdomain name) $m = example.net
              (node name) $k = mail
========================================================

Notice: -bv may give misleading output for non-privileged user
      END

      before :each do
        Facter::Core::Execution.stubs(:execute).with(command, options).returns(output)
      end
      it {
        expect(Facter.fact(:sendmail_version).value).to eq('8.14.4')
      }
    end

    context 'with strange value' do
      output = "Dummymail Version 3.14-alpha\n"

      before :each do
        Facter::Core::Execution.stubs(:execute).with(command, options).returns(output)
      end
      it {
        expect(Facter.fact(:sendmail_version).value).to be_nil
      }
    end

    context 'without value' do
      output = nil

      before :each do
        Facter::Core::Execution.stubs(:execute).with(command, options).returns(output)
      end
      it {
        expect(Facter.fact(:sendmail_version).value).to be_nil
      }
    end
  end
end
