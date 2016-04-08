require 'rubygems'
require 'hiera'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'

include RspecPuppetFacts

RSpec.configure do |c|

  # Hiera
  # c.hiera_config = File.join('spec', 'fixtures', 'hiera', 'hiera.yaml')

  # :id and :osfamily facts are needed for concat module
  c.default_facts = {
    :hostname         => 'cliff',
    :domain           => 'example.org',
    :fqdn             => 'cliff.example.org',
    :id               => 'stm',
    :osfamily         => 'Debian',
    :operatingsystem  => 'Debian',
    :concat_basedir   => '/var/tmp',
    :sendmail_version => '8.14.0',
  }
end

at_exit { RSpec::Puppet::Coverage::report! }
