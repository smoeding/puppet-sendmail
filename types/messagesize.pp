# @summary A message size specification in bytes, kb or Mb.
type Sendmail::Messagesize = Pattern[/^[0-9]*\s*([kM][bB])?$/]
