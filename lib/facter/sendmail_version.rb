# Fact: sendmail_version
#
# Get the sendmail version
#
Facter.add(:sendmail_version) do
  setcode do
    version = Facter::Util::Resolution.exec('sendmail -d0.4 -bv root')
    if version =~ /^Version ([0-9.]+)$/
      $1
    else
      nil
    end
  end
end
