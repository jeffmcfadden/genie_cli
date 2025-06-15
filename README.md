# Genie CLI

Genie CLI is a command-line tool that brings Test Driven Development (TDD) 
principles to life by integrating with a large language model (LLM) through 
the `ruby_llm` library. It provides an interactive session where you can ask 
the AI assistant to write tests, implement code, and manage your codebase—all 
while enforcing a strict TDD workflow.

## Features

- Interactive REPL-style session powered by OpenAI (or any provider supported by `ruby_llm`).
- Built-in tools for common file operations:
  - `ListFiles`: List and filter files in your project directory.
  - `ReadFile`: Read the contents of files.
  - `WriteFile`: Create or overwrite files.
  - `InsertIntoFile`: Insert content at a specific marker in a file.
  - `AppendToFile`: Append content to existing files.
  - `RunTests`: Run your test suite and capture results.
  - `TakeANote`: Write notes without affecting your source files.
  - `AskForHelp`: Request guidance or explanations from the AI.
- Enforces Genie workflow: tests first, implementation second.
- Restricts file operations to your project directory for safety.

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/jeffmcfadden/genie_cli.git
   cd genie_cli
   ```

2. Install dependencies using Bundler:
   ```bash
   bundle install
   ```

3. Set your OpenAI API key (or other LLM provider keys) in your environment:
   ```bash
   export OPENAI_API_KEY="your_api_key_here"
   ```

4. Make the CLI executable:
   ```bash
   chmod +x bin/genie
   ```

## Usage

Start a Genie session by running the `genie` command from the root of your project:

```bash
./bin/genie ["initial prompt or command"]
```

- If you provide an initial prompt, the assistant will immediately respond. Otherwise, you'll enter an interactive prompt where you can type your questions or commands.
- To quit the session, type `q`, `quit`, `done`, or `exit`.

Example session:

```bash
$ ./bin/genie
Starting a new session with:
 base_path: /Users/you/projects/genie_cli

 > "Create a failing test for a Calculator#add method"

# (AI writes a test file)

 > "Implement Calculator#add to pass the test"

# (AI writes the implementation)

 > "Run the test suite"

# (AI invokes `rake test` and reports results)

 > "exit"
Exiting...
Total Conversation Tokens: 1234
```

## Logging

The output of `genie` to the terminal includes "essential" output, but not 
_all_ output. To aid in debugging, the full RubyLLM debug log is saved to 
`ruby_llm.log`. This can be useful for auditing what's happened during a 
session in great detail.

## Configuration

Configuration is available via a `genie.yml` file in the project root.

## Testing

This project includes a comprehensive test suite. Run all tests with:

```bash
bundle exec rake test
```

## Contributing

Contributions are welcome! Please fork the repository and open pull requests for new features or bug fixes. Make sure to follow the Genie workflow and include tests for new functionality.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
