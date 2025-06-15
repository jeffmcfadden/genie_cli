# frozen_string_literal: true
require_relative "lib/genie/version"

Gem::Specification.new do |spec|
  spec.name          = "genie_cli"
  spec.version       = Genie::VERSION
  spec.authors       = ["Jeff McFadden"]
  spec.email         = ["jeff@example.com"]

  spec.summary       = %q{CLI Coding Agent written in Ruby.}
  spec.description   = %q{Genie CLI is a command-line tool that brings Test Driven Development (TDD) principles to life by integrating with a large language model (LLM) through the ruby_llm library. It provides an interactive session to write tests, implement code, and manage your codebase.}
  spec.homepage      = "https://github.com/jeffmcfadden/genie_cli"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.2"

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    Dir.glob("{bin/*,lib/**/*,README.md,LICENSE,Rakefile,test/**/*}")
  end

  spec.executables   = Dir.children("bin").map { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "tldr", ">= 1.0"
  spec.add_development_dependency "ruby_llm"
end
