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
