# @summary Manage various timeout settings in the 'sendmail.mc' file.
#
# This class allows setting various timeouts for Sendmail without having to
# use the `sendmail::mc::define` macro individually for each entry.
#
# @example Disable RFC1413 ident requests
#   class { 'sendmail::mc::timeouts':
#     ident => '0',
#   }
#
# @param aconnect Timeout for all connection attempts when trying to reach
#   one or multiple hosts for sending a single mail.
#
# @param auth Timeout when waiting for AUTH negotiation.
#
# @param command Timeout when waiting for the next SMTP command.
#
# @param connect Timeout for one connection attempt when trying to establish
#   a network connection.  Also see then `iconnect` parameter.
#
# @param control Timout when waiting for a command on the control socket.
#
# @param datablock Timeout when waiting on a read operation during the DATA
#   phase.
#
# @param datafinal Timeout when waiting for the acknowledgment after sending
#   the final dot in the DATA phase.
#
# @param datainit Timeout when waiting for the acknowledgment of the DATA
#   command.
#
# @param fileopen Timeout when waiting for access to a local file.
#
# @param helo Timeout when waiting for the acknowledgment of the HELO or EHLO
#   commands.
#
# @param hoststatus Timeout for invalidation of hoststatus information during
#   a single queue run.
#
# @param iconnect Timeout for the first connection attempt to a host when
#   trying to establish a network connection.  Also see then `connect`
#   parameter.
#
# @param ident Timeout when waiting to a response to a RFC1413 identification
#   protocol query.  Set this to `0` to disable the identification protocol.
#
# @param initial Timeout when waiting for the initial greeting message.
#
# @param lhlo Timeout when waiting for the reply to the initial LHLO command
#   on an LMTP connection.
#
# @param mail Timeout when waiting for the acknowledgment of the MAIL
#   command.
#
# @param misc Timeout when waiting for the acknowledgment of various other
#   commands (VERB, NOOP, ...).
#
# @param quit Timeout when waiting for the acknowledgment of the QUIT
#   command.
#
# @param rcpt Timeout when waiting for the acknowledgment of the RCPT
#   command.
#
# @param rset Timeout when waiting for the acknowledgment of the RSET
#   command.
#
# @param starttls Timeout when waiting for STARTTLS negotiation.
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
      'timeouts' => $timeouts.map |$key,$val| { "`confTO_${key}', `${val}'" },
    }

    concat::fragment { 'sendmail_mc-timeouts':
      target  => 'sendmail.mc',
      order   => '16',
      content => epp('sendmail/timeouts.m4.epp', $params),
    }
  }
}
