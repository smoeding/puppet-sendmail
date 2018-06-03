# sendmail_version.rb -- Get the Sendmail version
#
# Exim and Postfix both install a 'sendmail' executable to provide script
# compatibility with Sendmail. Unfortunately both do not implement it to the
# point we need here. So we check for the 'exim' and 'postconf' executables
# and conclude that Sendmail is not installed if either of them is found.
# Otherwise we might cause logfile errors by calling 'sendmail' when a
# different mailer is used.

# For Sendmail this fact tries to verify a random username to get the
# sendmail version number. This should minimize the dependency on DNS when
# the fact is called.

Facter.add(:sendmail_version) do
  setcode do
    options = { :on_fail => nil, :timeout => 30 }

    smcmd = 'sendmail -d0.1 -ODontProbeInterfaces=true -bv moowoc6ji5'

    begin
      if Facter::Core::Execution.which('exim')
        # Exim is installed here, so no version of Sendmail
        nil
      elsif Facter::Core::Execution.which('postfix')
        # Postfix is installed here, so no version of Sendmail
        nil
      else
        version = Facter::Core::Execution.execute(smcmd, options)
        if version =~ /^Version ([0-9.]+).*$/
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
