class Cleaner
  
  attr_reader :path, :options
  
  VALID_OPTIONS    = [:threshold, :pretend, :verbose]
  VALID_INTERVALS  = [:hourly, :daily, :weekly, :monthly, :yearly]
  TIME_INTERVALS   = [:hour,   :day,   :cweek, :month, :year]
  
  def initialize(path, options = {})
    @path = path
    @options = options
    options.assert_valid_keys(VALID_OPTIONS + VALID_INTERVALS)
    given_intervals = VALID_INTERVALS & options.keys
    if given_intervals.present?
      lowest_selected_position = VALID_INTERVALS.index(given_intervals.first)
      @key_intervals = TIME_INTERVALS[lowest_selected_position..-1]
    end
  end
  
  def start
    files = files_to_delete.map(&:path)
    puts files.join("\n") if options[:verbose]
    FileUtils.rm(files, :noop => !!options[:pretend], :force => true)
  end
  
  def files
    raise "No such directory: #{path}" unless File.directory?(path)
    @_files ||= Dir.glob(path + '/*').map do |file_path| 
      File.new(file_path)
    end.sort_by(&:ctime)
  end
  
  def files_to_delete
    files_before_threshold - files_to_preserve
  end
  
  def files_before_threshold
    files.delete_if{|file| file.ctime >= options[:threshold]}
  end
  
  def files_to_preserve
    return files_before_threshold if @key_intervals.nil?
    files_before_threshold.group_by do |file|
      cdate = file.ctime.to_datetime
      @key_intervals.map{|interval| cdate.send(interval)}
    end.map do |_, files|
      files.first
    end
  end
end