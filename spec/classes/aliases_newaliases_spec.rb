require 'spec_helper'

describe 'sendmail::aliases::newaliases' do
  it {
    should contain_class('sendmail::params')
    should contain_exec('sendmail::aliases::newaliases').with(
             'command'     => '/usr/sbin/sendmail -bi',
             'refreshonly' => 'true',
           )
  }
end
