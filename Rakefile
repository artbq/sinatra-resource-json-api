require "rspec/core/rake_task"
require "bundler/gem_tasks"

RSpec::Core::RakeTask.new(:spec)

ENV["gem_push"] = "false"

Rake::Task["release"].enhance do
  spec = Gem::Specification::load(Dir.glob("*.gemspec").first)
  sh "gem inabox pkg/#{spec.name}-#{spec.version}.gem"
end

