require 'cc/engine/analyzers/ruby/main'
require 'cc/engine/analyzers/javascript/main'
require 'cc/engine/analyzers/php/main'
require 'cc/engine/analyzers/python/main'
require 'cc/engine/analyzers/reporter'
require 'flay'
require 'json'

module CC
  module Engine
    class Duplication
      DEFAULT_LANGUAGE = ['ruby'].freeze
      LANGUAGES = {
        "ruby"       => ::CC::Engine::Analyzers::Ruby::Main,
        "javascript" => ::CC::Engine::Analyzers::Javascript::Main,
        "php"        => ::CC::Engine::Analyzers::Php::Main,
        "python"     => ::CC::Engine::Analyzers::Python::Main,
      }.freeze

      def initialize(directory:, engine_config:, io:)
        @directory = directory
        @engine_config = engine_config || {}
        @io = io
      end

      def run
        languages_to_analyze.each do |language|
          engine = LANGUAGES[language].new(directory: directory, engine_config: engine_config)
          reporter = CC::Engine::Analyzers::Reporter.new(directory, engine, io)
          reporter.run
        end
      end

      private

      attr_reader :directory, :engine_config, :io

      def languages_to_analyze
        languages.select do |language|
          LANGUAGES.keys.include?(language)
        end
      end

      def languages
        Array(engine_config['languages'] || DEFAULT_LANGUAGE)
      end
    end
  end
end
