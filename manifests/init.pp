# == Class: sendmail
#
# Manage the sendmail MTA
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Examples
#
#  class { 'sendmail:
#  }
#
# === Authors
#
# Stefan Moeding <stm@kill-9.net>
#
# === Copyright
#
# Copyright 2015 Stefan Moeding
#
class sendmail {

  anchor { '::sendmail::begin': }
  anchor { '::sendmail::end': }
}
