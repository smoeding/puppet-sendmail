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
  Optional[String] $aconnect   = undef,
  Optional[String] $auth       = undef,
  Optional[String] $command    = undef,
  Optional[String] $connect    = undef,
  Optional[String] $control    = undef,
  Optional[String] $datablock  = undef,
  Optional[String] $datafinal  = undef,
  Optional[String] $datainit   = undef,
  Optional[String] $fileopen   = undef,
  Optional[String] $helo       = undef,
  Optional[String] $hoststatus = undef,
  Optional[String] $iconnect   = undef,
  Optional[String] $ident      = undef,
  Optional[String] $initial    = undef,
  Optional[String] $lhlo       = undef,
  Optional[String] $mail       = undef,
  Optional[String] $misc       = undef,
  Optional[String] $quit       = undef,
  Optional[String] $rcpt       = undef,
  Optional[String] $rset       = undef,
  Optional[String] $starttls   = undef,
) {
  $sparse_timeouts = {
    'ACONNECT'   => $aconnect,
    'AUTH'       => $auth,
    'COMMAND'    => $command,
    'CONNECT'    => $connect,
    'CONTROL'    => $control,
    'DATABLOCK'  => $datablock,
    'DATAFINAL'  => $datafinal,
    'DATAINIT'   => $datainit,
    'FILEOPEN'   => $fileopen,
    'HELO'       => $helo,
    'HOSTSTATUS' => $hoststatus,
    'ICONNECT'   => $iconnect,
    'IDENT'      => $ident,
    'INITIAL'    => $initial,
    'LHLO'       => $lhlo,
    'MAIL'       => $mail,
    'MISC'       => $misc,
    'QUIT'       => $quit,
    'RCPT'       => $rcpt,
    'RSET'       => $rset,
    'STARTTLS'   => $starttls,
  }

  # Remove unset options
  $timeouts = $sparse_timeouts.filter |$key,$val| { !empty($val) }

  if ($timeouts and !empty($timeouts)) {
    $params = {
      'timeouts' => $timeouts.map |$key,$val| { "`confTO_${key}', `${val}'" }
    }

    concat::fragment { 'sendmail_mc-timeouts':
      target  => 'sendmail.mc',
      order   => '16',
      content => epp('sendmail/timeouts.m4.epp', $params),
    }
  }
}
