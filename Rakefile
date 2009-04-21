require 'rake'
require 'rake/testtask'

desc "Run all specs by default"
task :default => :all_tests

task :all_tests do
  system "rake test | tee test_results.txt"
end

Rake::TestTask.new(:test) do |t|
  ENV['TESTOPTS'] = '--runner=s'

  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
