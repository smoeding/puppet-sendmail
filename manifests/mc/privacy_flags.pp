# = Class: sendmail::mc::privacy_flags
#
# Manage privacy flags for the Sendmail MTA
#
# == Parameters:
#
# [*authwarnings*]
#   Whether the privacy option of the same name should be enabled. Valid
#   options: 'true' or 'false'. Default value: 'false'
#
# [*goaway*]
#   Whether the privacy option of the same name should be enabled. Valid
#   options: 'true' or 'false'. Default value: 'false'
#
# [*needexpnhelo*]
#   Whether the privacy option of the same name should be enabled. Valid
#   options: 'true' or 'false'. Default value: 'false'
#
# [*needmailhelo*]
#   Whether the privacy option of the same name should be enabled. Valid
#   options: 'true' or 'false'. Default value: 'false'
#
# [*needvrfyhelo*]
#   Whether the privacy option of the same name should be enabled. Valid
#   options: 'true' or 'false'. Default value: 'false'
#
# [*noactualrecipient*]
#   Whether the privacy option of the same name should be enabled. Valid
#   options: 'true' or 'false'. Default value: 'false'
#
# [*nobodyreturn*]
#   Whether the privacy option of the same name should be enabled. Valid
#   options: 'true' or 'false'. Default value: 'false'
#
# [*noetrn*]
#   Whether the privacy option of the same name should be enabled. Valid
#   options: 'true' or 'false'. Default value: 'false'
#
# [*noexpn*]
#   Whether the privacy option of the same name should be enabled. Valid
#   options: 'true' or 'false'. Default value: 'false'
#
# [*noreceipts*]
#   Whether the privacy option of the same name should be enabled. Valid
#   options: 'true' or 'false'. Default value: 'false'
#
# [*noverb*]
#   Whether the privacy option of the same name should be enabled. Valid
#   options: 'true' or 'false'. Default value: 'false'
#
# [*novrfy*]
#   Whether the privacy option of the same name should be enabled. Valid
#   options: 'true' or 'false'. Default value: 'false'
#
# [*public*]
#   Whether the privacy option of the same name should be enabled. Valid
#   options: 'true' or 'false'. Default value: 'false'
#
# [*restrictexpand*]
#   Whether the privacy option of the same name should be enabled. Valid
#   options: 'true' or 'false'. Default value: 'false'
#
# [*restrictmailq*]
#   Whether the privacy option of the same name should be enabled. Valid
#   options: 'true' or 'false'. Default value: 'false'
#
# [*restrictqrun*]
#   Whether the privacy option of the same name should be enabled. Valid
#   options: 'true' or 'false'. Default value: 'false'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'sendmail::mc::privacy_flags':
#     authwarnings => true,
#     noetrn       => true,
#   }
#
#
class sendmail::mc::privacy_flags (
  $authwarnings      = false,
  $goaway            = false,
  $needexpnhelo      = false,
  $needmailhelo      = false,
  $needvrfyhelo      = false,
  $noactualrecipient = false,
  $nobodyreturn      = false,
  $noetrn            = false,
  $noexpn            = false,
  $noreceipts        = false,
  $noverb            = false,
  $novrfy            = false,
  $public            = false,
  $restrictexpand    = false,
  $restrictmailq     = false,
  $restrictqrun      = false,
) {

  validate_bool($authwarnings)
  validate_bool($goaway)
  validate_bool($needexpnhelo)
  validate_bool($needmailhelo)
  validate_bool($needvrfyhelo)
  validate_bool($noactualrecipient)
  validate_bool($nobodyreturn)
  validate_bool($noetrn)
  validate_bool($noexpn)
  validate_bool($noreceipts)
  validate_bool($noverb)
  validate_bool($novrfy)
  validate_bool($public)
  validate_bool($restrictexpand)
  validate_bool($restrictmailq)
  validate_bool($restrictqrun)

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

  ::sendmail::mc::define { 'confPRIVACY_FLAGS':
    expansion => join($real_flags, ','),
  }
}
