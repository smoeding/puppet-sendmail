# Fact: sendmail_version
#
# Get the sendmail version
#
Facter.add(:sendmail_version) do
  setcode do
    begin
      options = { :on_fail => nil, :timeout => 10 }
      command = 'sendmail -d0.4 -ODontProbeInterfaces=true -bv root 2>/dev/null'
      version = Facter::Core::Execution.execute(command, options)
      if version =~ /^Version ([0-9.]+)$/
        $1
      else
        nil
      end
    rescue Facter::Core::Execution::ExecutionFailure
      nil
    end
  end
end
