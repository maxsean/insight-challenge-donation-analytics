begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = 'insight_testsuite/tests/spec/*_spec.rb'
  end

  task default: :spec
rescue LoadError
  puts "Please 'bundle', first."
end
