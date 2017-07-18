# sendmail_version.rb -- Get the Sendmail version
#
# Exim and Postfix both install a 'sendmail' executable to provide script
# compatibility with Sendmail. Unfortunately both do not implement it to the
# point we need here. So we check for the 'exim' and 'postconf' executables
# and conclude that Sendmail is not installed if either of them is found.
# Otherwise we might cause logfile errors by calling 'sendmail' when a
# different mailer is used.

Facter.add(:sendmail_version) do
  setcode do
    options = { :on_fail => nil, :timeout => 10 }

    excmd = 'exim -bV'
    pfcmd = 'postconf -h mail_version'
    smcmd = 'sendmail -d0.4 -ODontProbeInterfaces=true -bv root 2>/dev/null'

    begin
      if Facter::Core::Execution.execute(excmd, options)
        # Exim is running here, so no version of Sendmail
        nil
      elsif Facter::Core::Execution.execute(pfcmd, options)
        # Postfix is running here, so no version of Sendmail
        nil
      else
        version = Facter::Core::Execution.execute(smcmd, options)
        if version =~ /^Version ([0-9.]+)$/
          $1
        else
          nil
        end
      end
    rescue Facter::Core::Execution::ExecutionFailure
      nil
    end
  end
end
