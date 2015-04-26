# = Class: sendmail::mc
#
# Manage the sendmail.mc file
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
#   class { '::sendmail::mc': }
#
#
class sendmail::mc {

  include ::sendmail::params

  # Order of fragments
  # -------------------------
  # 00    # file header
  # 01    VERSIONID
  # 05    OSTYPE
  # 10    # define header
  # 12    define
  # 30    # FEATURE header
  # 32    FEATURE
  # 40    # macro header
  # 58    MODIFY_MAILER_FLAGS
  # 60    DAEMON_OPTIONS
  # 75    TRUST_AUTH_MECH
  # 80    # MAILER header
  # 81-89 MAILER

  concat { 'sendmail.mc':
    ensure => 'present',
    path   => '/tmp/sendmail.mc',
    owner  => 'root',
    group  => $::sendmail::params::sendmail_group,
    mode   => '0644',
  }

  concat::fragment { 'sendmail_mc-header':
    target  => 'sendmail.mc',
    order   => '00',
    content => template('sendmail/header.m4.erb'),
    notify  => Class['::sendmail::makeall'],
  }


}
