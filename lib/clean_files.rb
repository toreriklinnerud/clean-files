require 'optparse' 
require 'rdoc/usage'
require 'ostruct'
require 'active_support'
require 'date'

require 'cleaner'

class CleanFiles
  VERSION = '0.0.1'
  
  attr_reader :options

  def initialize(arguments)
    @arguments = arguments
    
    # Set defaults
    @options = OpenStruct.new
    @options.verbose   = false
    @options.dry_run   = false
    @options.threshold = 1.month.ago
  end

  # Parse options, check arguments, then process the command
  def run
        
    if parsed_options? && arguments_valid? 
      Cleaner.new(@options.path, @options.marshal_dump).start
    else
      output_usage
    end
      
  end
  
  protected
  
    def parsed_options?
      
      # Specify options
      opts = OptionParser.new 
      opts.on('-h', '--help')       { output_help }
      opts.on('-v', '--verbose')    { @options.verbose = true }
      opts.on('-d', '--dry-run')    { @options.verbose = true 
                                      @options.dry_run = true }
      opts.on('-t', '--treshold [TIME]')   {|time| @options.threshold = eval(time)}
            
      return false unless opts.parse!(@arguments)
      
      @options.path = @arguments.pop

      true      
    end

    def arguments_valid?
      @arguments.empty? && @options.path
    end
    
    def output_help
      output_version
      RDoc::usage()
    end
    
    def output_usage
      RDoc::usage('Usage', 'Options')
    end
        
end