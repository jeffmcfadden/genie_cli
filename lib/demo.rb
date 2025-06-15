require_relative "./tdd"

# Base path is one level up from this file:

base_path = File.expand_path("../", __dir__)

session = TDD::Session.new(base_path: base_path,
                           run_tests_cmd: "bundle exec tldr --fail-fast")

session.ask "Add a new tool that will append a string to a file."
