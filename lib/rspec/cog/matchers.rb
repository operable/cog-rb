# This is what you want to use for commands that return raw text
RSpec::Matchers.define :respond_with_text do |expected|
  match do |command|
    @actual = command.response.content["body"]
    @actual == expected
  end
  diffable
end

# Use this when dealing with commands that return data structures
RSpec::Matchers.define :respond_with do |expected|
  match do |command|
    @actual = command.response.content
    @actual == expected
  end
  diffable
end
