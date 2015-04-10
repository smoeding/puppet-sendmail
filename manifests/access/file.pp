# = Class: sendmail::access::file
#
# Create the Sendmail access db file.
#
# == Parameters:
#
# None.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'sendmail::access::file': }
#
#
class sendmail::access::file {
  include ::sendmail::params

  file { '/etc/mail/access':
    ensure => file,
    owner  => 'smmta',
    group  => 'smmsp',
    mode   => '0640',
  }
}
