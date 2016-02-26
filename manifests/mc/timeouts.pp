# = Class: sendmail::mc::timeouts
#
# Manage various timeout settings in the 'sendmail.mc' file.
#
# == Parameters:
#
# [*aconnect*]
#   Timeout for all connection attempts when trying to reach one or multiple
#   hosts for  sending a single mail. Default value: undef
#
# [*auth*]
#   Timeout when waiting for AUTH negotiation. Default value: undef
#
# [*command*]
#   Timeout when waiting for the next SMTP command. Default value: undef
#
# [*connect*]
#   Timeout for one connection attempt when trying to establish a network
#   connection. Also see then 'iconnect' parameter. Default value: undef
#
# [*control*]
#   Timout when waiting for a command on the control socket.
#   Default value: undef
#
# [*datablock*]
#   Timeout when waiting on a read operation during the DATA phase.
#   Default value: undef
#
# [*datafinal*]
#   Timeout when waiting for the acknowledgment after sending the final dot
#   in the DATA phase. Default value: undef
#
# [*datainit*]
#   Timeout when waiting for the acknowledgment of the DATA command.
#   Default value: undef
#
# [*fileopen*]
#   Timeout when waiting for access to a local file. Default value: undef
#
# [*helo*]
#   Timeout when waiting for the acknowledgment of the HELO or EHLO commands.
#   Default value: undef
#
# [*hoststatus*]
#   Timeout for invalidation of hoststatus information during a single queue
#   run. Default value: undef
#
# [*iconnect*]
#   Timeout for the first connection attempt to a host when trying to
#   establish a network connection. Also see then 'connect' parameter.
#   Default value: undef
#
# [*ident*]
#   Timeout when waiting to a response to a RFC1413 identification protocol
#   query. Set this to '0' to disable the identification protocol.
#   Default value: undef
#
# [*initial*]
#   Timeout when waiting for the initial greeting message.
#   Default value: undef
#
# [*lhlo*]
#   Timeout when waiting for the reply to the initial LHLO command on an
#   LMTP connection. Default value: undef
#
# [*mail*]
#   Timeout when waiting for the acknowledgment of the MAIL command.
#   Default value: undef
#
# [*misc*]
#   Timeout when waiting for the acknowledgment of various other commands
#   (VERB, NOOP, ...). Default value: undef
#
# [*quit*]
#   Timeout when waiting for the acknowledgment of the QUIT command.
#   Default value: undef
#
# [*rcpt*]
#   Timeout when waiting for the acknowledgment of the RCPT command.
#   Default value: undef
#
# [*rset*]
#   Timeout when waiting for the acknowledgment of the RSET command.
#   Default value: undef
#
# [*starttls*]
#   Timeout when waiting for STARTTLS negotiation. Default value: undef
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'sendmail::mc::timeouts': }
#
#
class sendmail::mc::timeouts (
  $aconnect   = undef,
  $auth       = undef,
  $command    = undef,
  $connect    = undef,
  $control    = undef,
  $datablock  = undef,
  $datafinal  = undef,
  $datainit   = undef,
  $fileopen   = undef,
  $helo       = undef,
  $hoststatus = undef,
  $iconnect   = undef,
  $ident      = undef,
  $initial    = undef,
  $lhlo       = undef,
  $mail       = undef,
  $misc       = undef,
  $quit       = undef,
  $rcpt       = undef,
  $rset       = undef,
  $starttls   = undef,
) {

  $sparse_timeouts = [
    "`confTO_ACONNECT', `${aconnect}'",
    "`confTO_AUTH', `${auth}'",
    "`confTO_COMMAND', `${command}'",
    "`confTO_CONNECT', `${connect}'",
    "`confTO_CONTROL', `${control}'",
    "`confTO_DATABLOCK', `${datablock}'",
    "`confTO_DATAFINAL', `${datafinal}'",
    "`confTO_DATAINIT', `${datainit}'",
    "`confTO_FILEOPEN', `${fileopen}'",
    "`confTO_HELO', `${helo}'",
    "`confTO_HOSTSTATUS', `${hoststatus}'",
    "`confTO_ICONNECT', `${iconnect}'",
    "`confTO_IDENT', `${ident}'",
    "`confTO_INITIAL', `${initial}'",
    "`confTO_LHLO', `${lhlo}'",
    "`confTO_MAIL', `${mail}'",
    "`confTO_MISC', `${misc}'",
    "`confTO_QUIT', `${quit}'",
    "`confTO_RCPT', `${rcpt}'",
    "`confTO_RSET', `${rset}'",
    "`confTO_STARTTLS', `${starttls}'",
  ]

  # Remove unset options
  $timeouts = delete(regsubst($sparse_timeouts, "^.*, `'$", '='), '=')

  if ($timeouts and !empty($timeouts)) {
    concat::fragment { 'sendmail_mc-timeouts':
      target  => 'sendmail.mc',
      order   => '16',
      content => template('sendmail/timeouts.m4.erb'),
      notify  => Class['::sendmail::makeall'],
    }
  }
}
