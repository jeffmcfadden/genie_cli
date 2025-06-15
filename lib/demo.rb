require_relative "./tdd"

# Base path is one level up from this file:

session = TDD::Session.new(base_path: File.expand_path("..", __dir__))

session.ask "Examine the codebase at '/Users/jeffmcfadden/code/tdd_cli' to understand what it does, them summarize."

session.ask "Update the Session class to take a base_path argument and store it. It should be read-only once set."
