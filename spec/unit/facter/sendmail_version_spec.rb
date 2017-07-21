require 'spec_helper'

describe Facter::Util::Fact do
  before {
    Facter.clear
  }

  describe 'sendmail_version' do
    excmd = 'exim -bV'
    pfcmd = 'postconf -h mail_version'
    smcmd = 'sendmail -d0.4 -ODontProbeInterfaces=true -bv root 2>/dev/null'

    options = { :on_fail => nil, :timeout => 10 }

    context 'with standard version number' do
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
        Facter::Core::Execution.stubs(:execute).with(excmd, options) \
          .returns(nil)
        Facter::Core::Execution.stubs(:execute).with(pfcmd, options) \
          .returns(nil)
        Facter::Core::Execution.stubs(:execute).with(smcmd, options) \
          .returns(output)
      end
      it {
        expect(Facter.fact(:sendmail_version).value).to eq('8.14.4')
      }
    end

    context 'with distribution version number' do
      output = <<-END
Version 8.14.4-Sun
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
        Facter::Core::Execution.stubs(:execute).with(excmd, options) \
          .returns(nil)
        Facter::Core::Execution.stubs(:execute).with(pfcmd, options) \
          .returns(nil)
        Facter::Core::Execution.stubs(:execute).with(smcmd, options) \
          .returns(output)
      end
      it {
        expect(Facter.fact(:sendmail_version).value).to eq('8.14.4')
      }
    end

    context 'with some strange value' do
      output = "Dummymail Version 3.14-alpha\n"

      before :each do
        Facter::Core::Execution.stubs(:execute).with(excmd, options) \
          .returns(nil)
        Facter::Core::Execution.stubs(:execute).with(pfcmd, options) \
          .returns(nil)
        Facter::Core::Execution.stubs(:execute).with(smcmd, options) \
          .returns(output)
      end
      it {
        expect(Facter.fact(:sendmail_version).value).to be_nil
      }
    end

    context 'without no sendmail executable' do
      output = nil

      before :each do
        Facter::Core::Execution.stubs(:execute).with(excmd, options) \
          .returns(nil)
        Facter::Core::Execution.stubs(:execute).with(pfcmd, options) \
          .returns(nil)
        Facter::Core::Execution.stubs(:execute).with(smcmd, options) \
          .returns(output)
      end
      it {
        expect(Facter.fact(:sendmail_version).value).to be_nil
      }
    end

    context 'with exim mailer' do
      output = <<-END
Exim version 4.84_2 #1 built 14-Jun-2017 14:43:28
Copyright (c) University of Cambridge, 1995 - 2014
(c) The Exim Maintainers and contributors in ACKNOWLEDGMENTS file, 2007 - 2014
Berkeley DB: Berkeley DB 5.3.28: (September  9, 2013)
Support for: crypteq iconv() IPv6 PAM Perl Expand_dlfunc GnuTLS
move_frozen_messages Content_Scanning DKIM Old_Demime PRDR OCSP
Lookups (built-in): lsearch wildlsearch nwildlsearch iplsearch cdb dbm dbmjz
dbmnz dnsdb dsearch ldap ldapdn ldapm mysql nis nis0 passwd pgsql sqlite
Authenticators: cram_md5 cyrus_sasl dovecot plaintext spa
Routers: accept dnslookup ipliteral iplookup manualroute queryprogram redirect
Transports: appendfile/maildir/mailstore/mbx autoreply lmtp pipe smtp
Fixed never_users: 0
Size of off_t: 8
Configuration file is /etc/exim4/exim4.conf
      END

      before :each do
        Facter::Core::Execution.stubs(:execute).with(excmd, options) \
          .returns(output)
        # Postfix and Sendmail not called
      end
      it {
        expect(Facter.fact(:sendmail_version).value).to be_nil
      }
    end

    context 'with postfix mailer' do
      output = '2.7.1'

      before :each do
        Facter::Core::Execution.stubs(:execute).with(excmd, options) \
          .returns(nil)
        Facter::Core::Execution.stubs(:execute).with(pfcmd, options) \
          .returns(output)
        # Sendmail not called
      end
      it {
        expect(Facter.fact(:sendmail_version).value).to be_nil
      }
    end
  end
end
