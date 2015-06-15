require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  # :id and :osfamily facts are needed for concat module
  c.default_facts = {
    :fqdn            => 'mail.example.org',
    :id              => 'stm',
    :osfamily        => 'Debian',
    :operatingsystem => 'Debian',
    :concat_basedir  => '/var/tmp',
  }
end
