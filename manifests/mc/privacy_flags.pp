# @summary Manage privacy flags for the Sendmail MTA
#
# Each option is enabled by setting the associated boolean parameter to
# `true`. See the Sendmail documentation for the meaning of the flags.
#
# @example Enable two specific privacy flags
#   class { 'sendmail::mc::privacy_flags':
#     goaway => true,
#     noetrn => true,
#   }
#
# @param authwarnings Whether the privacy option of the same name should be
#   enabled.  Valid options: `true` or `false`.
#
# @param goaway Whether the privacy option of the same name should be
#   enabled.  Valid options: `true` or `false`.
#
# @param needexpnhelo Whether the privacy option of the same name should be
#   enabled.  Valid options: `true` or `false`.
#
# @param needmailhelo Whether the privacy option of the same name should be
#   enabled.  Valid options: `true` or `false`.
#
# @param needvrfyhelo Whether the privacy option of the same name should be
#   enabled.  Valid options: `true` or `false`.
#
# @param noactualrecipient Whether the privacy option of the same name should
#   be enabled.  Valid options: `true` or `false`.
#
# @param nobodyreturn Whether the privacy option of the same name should be
#   enabled.  Valid options: `true` or `false`.
#
# @param noetrn Whether the privacy option of the same name should be
#   enabled.  Valid options: `true` or `false`.
#
# @param noexpn Whether the privacy option of the same name should be
#   enabled.  Valid options: `true` or `false`.
#
# @param noreceipts Whether the privacy option of the same name should be
#   enabled.  Valid options: `true` or `false`.
#
# @param noverb Whether the privacy option of the same name should be
#   enabled.  Valid options: `true` or `false`.
#
# @param novrfy Whether the privacy option of the same name should be
#   enabled.  Valid options: `true` or `false`.
#
# @param public Whether the privacy option of the same name should be
#   enabled.  Valid options: `true` or `false`.
#
# @param restrictexpand Whether the privacy option of the same name should be
#   enabled.  Valid options: `true` or `false`.
#
# @param restrictmailq Whether the privacy option of the same name should be
#   enabled.  Valid options: `true` or `false`.
#
# @param restrictqrun Whether the privacy option of the same name should be
#   enabled.  Valid options: `true` or `false`.
#
#
class sendmail::mc::privacy_flags (
  Boolean $authwarnings      = false,
  Boolean $goaway            = false,
  Boolean $needexpnhelo      = false,
  Boolean $needmailhelo      = false,
  Boolean $needvrfyhelo      = false,
  Boolean $noactualrecipient = false,
  Boolean $nobodyreturn      = false,
  Boolean $noetrn            = false,
  Boolean $noexpn            = false,
  Boolean $noreceipts        = false,
  Boolean $noverb            = false,
  Boolean $novrfy            = false,
  Boolean $public            = false,
  Boolean $restrictexpand    = false,
  Boolean $restrictmailq     = false,
  Boolean $restrictqrun      = false,
) {

  $flags = [
    bool2str($authwarnings,      'authwarnings',      ''),
    bool2str($goaway,            'goaway',            ''),
    bool2str($needexpnhelo,      'needexpnhelo',      ''),
    bool2str($needmailhelo,      'needmailhelo',      ''),
    bool2str($needvrfyhelo,      'needvrfyhelo',      ''),
    bool2str($noactualrecipient, 'noactualrecipient', ''),
    bool2str($nobodyreturn,      'nobodyreturn',      ''),
    bool2str($noetrn,            'noetrn',            ''),
    bool2str($noexpn,            'noexpn',            ''),
    bool2str($noreceipts,        'noreceipts',        ''),
    bool2str($noverb,            'noverb',            ''),
    bool2str($novrfy,            'novrfy',            ''),
    bool2str($public,            'public',            ''),
    bool2str($restrictexpand,    'restrictexpand',    ''),
    bool2str($restrictmailq,     'restrictmailq',     ''),
    bool2str($restrictqrun,      'restrictqrun',      ''),
  ]

  # Remove empty flags
  $real_flags = filter($flags) |$f| { !empty($f) }

  sendmail::mc::define { 'confPRIVACY_FLAGS':
    expansion => join($real_flags, ','),
  }
}
