class Cleaner
  
  attr_reader :path, :options
  
  VALID_INTERVALS  = [:hourly, :daily, :weekly, :monthly, :yearly]
  TIME_INTERVALS   = [:hour,   :day,   :cweek, :month, :year]
  
  def initialize(path, options)
    @path = path
    @options = options
    options.assert_valid_keys([:threshold] + VALID_INTERVALS)
    given_intervals = VALID_INTERVALS & options.keys
    if given_intervals.present?
      lowest_selected_position = VALID_INTERVALS.index(given_intervals.first)
      @key_intervals = TIME_INTERVALS[lowest_selected_position..-1]
    end
  end
  
  def start
    puts 'would delete: '
    files_before_threshold.each {|file_name| puts file_name}
  end
  
  def files
    raise "No such directory: #{path}" unless File.directory?(path)
    Dir.glob(path + '/*') do |file_path| 
      File.new(file_path)
    end.sort_by(&:ctime)
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