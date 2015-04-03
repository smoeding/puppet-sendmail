require 'rake'
require 'rspec/core/rake_task'
require 'puppet-lint/tasks/puppet-lint'

RSpec::Core::RakeTask.new(:spec) do |t|
6   t.pattern = 'spec/*/*_spec.rb'
7 end

task :default => [:spec, :lint]
