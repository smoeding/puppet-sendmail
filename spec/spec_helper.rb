require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  # :id and :osfamily facts are needed for concat module
  c.default_facts = {
    :hostname        => 'cliff',
    :domain          => 'example.org',
    :fqdn            => 'cliff.example.org',
    :id              => 'stm',
    :osfamily        => 'Debian',
    :operatingsystem => 'Debian',
    :concat_basedir  => '/var/tmp',
  }
end

at_exit { RSpec::Puppet::Coverage::report! }
