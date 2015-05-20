# Fact: sendmail_version
#
# Get the sendmail version
#
Facter.add(:sendmail_version) do
  setcode do
    command = 'sendmail -d0.4 -ODontProbeInterfaces=true -bv root'
    version = Facter::Util::Resolution.exec(command)
    if version =~ /^Version ([0-9.]+)$/
      $1
    else
      nil
    end
  end
end
