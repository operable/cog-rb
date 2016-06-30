# This is what you want to use for commands that return raw text
RSpec::Matchers.define :respond_with_text do |expected|
  match do |command|
    @actual = command.response.content["body"]
    @actual == expected
  end
  diffable
end
