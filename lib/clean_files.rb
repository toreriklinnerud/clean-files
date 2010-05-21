require 'optparse'
require 'active_support'
require 'fileutils'

require 'cleaner'

class CleanFiles
  VERSION = '0.1.0'

  attr_reader :options

  def initialize(arguments)
    @arguments = arguments

    # Set defaults
    @options = Hash.new
    @options[:threshold] = 1.month.ago
  end

  # Parse options, check arguments, then process the command
  def run

    if parsed_options? && arguments_valid?
      Cleaner.new(@options.delete(:paths), @options).start
    else
      output_usage
    end

  end

  protected

    def parsed_options?

      # Specify options
      opts = OptionParser.new
      opts.on('-h', '--help')       { output_help }
      opts.on('-v', '--verbose')    { @options[:verbose] = true }
      opts.on('-d', '--pretend')    { @options[:pretend] = true
                                      @options[:verbose] = true }
      opts.on('-r', '--recursive')  {@options[:recursive] = true }

      opts.on('-t', '--treshold [DAYS]')   do |days|
        raise OptionParser::InvalidOption unless days.to_i > 0 || days == "0"
        @options[:threshold] = days.to_i.send(:days).ago
      end

      Cleaner::VALID_INTERVALS.each do |interval|
        opts.on("-#{interval.to_s.first.upcase}", "--#{interval}") {@options[interval] =  true}
      end
      return false unless opts.parse!(@arguments)

      @options[:paths] = @arguments.dup

      true
    end

    def arguments_valid?
      @options[:paths].present?
    end

    def output_help
      rdoc
      exit -1
    end

    def output_usage
      rdoc('Usage', 'Options')
      exit -1
    end

    def rdoc(*sections)
      readme_path = File.join(File.dirname(__FILE__), '/../README.rdoc')
      comment = File.read(readme_path)

      markup = SM::SimpleMarkup.new
      flow_convertor = SM::ToFlow.new
      flow = markup.convert(comment, flow_convertor)
      format = "plain"

      unless sections.empty?
        flow = RDoc.extract_sections(flow, sections)
      end

      options = RI::Options.instance

      formatter = options.formatter.new(options, "")
      formatter.display_flow(flow)
    end

end