module RSpecLabHelper

  def self.setupLab labSpecFolder, title
    RSpecLab.new File.dirname(labSpecFolder), title
  end

  class RSpecLab
    def initialize(labPath, title, requirePaths = nil)
      @labPath = labPath
      @projectPath = File.dirname @labPath

      @requirePaths = requirePaths
      @title = title

      puts "Setting up #{title} Test Suite"

      if @requirePaths.nil?
        @requirePaths = []
        @requirePaths.push "#{labPath}/lib/*.rb" if Dir.exist?(labPath + "/lib/")
      end

      setupRspec
    end

    def setupRspec
      loadCodeToTest
      loadSharedRSpecExamples
      RSpec.configure do |config|
        # config.treat_symbols_as_metadata_keys_with_true_values = true
        # config.run_all_when_everything_filtered = true
        # config.filter_run :focus
        config.order = 'defined'
        config.fail_fast = true
      end
      self
    end

    def loadSharedRSpecExamples
      shared_examples = "#{@projectPath}/shared/spec/**/*.rb"

      puts "Loading shared tests from #{shared_examples}"
      Dir[shared_examples].sort.each do |f|
        puts "Loading #{f}"
        require f
      end
    end


    def loadCodeToTest
      @requirePaths.each do |path|
        puts "Loading ruby code via require from #{path}"
        Dir[path].sort.each do |f|
          puts "Loading #{f}"
          require f
        end
      end
    end
  end
end
