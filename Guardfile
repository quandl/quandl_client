group :specs do
  guard :rspec, cmd: 'bundle exec rspec --fail-fast -f doc --color' do
      watch(%r{^spec/.+_spec\.rb$})
      watch(%r{^(lib/.+)\.rb$})                { |m| "spec/#{m[1]}_spec.rb" }
      watch('spec/spec_helper.rb')             { 'spec' }
  end
end

