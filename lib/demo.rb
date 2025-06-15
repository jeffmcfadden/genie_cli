require_relative "./tdd"

session = TDD::Session.new

session.ask "Examine the codebase at '/Users/jeffmcfadden/code/tdd_cli' to understand what it does, them summarize."

session.ask "Update the Session class to take a base_path argument and store it. It should be read-only once set."
