require 'active_support'
class Cleaner
  attr_reader :paths, :options

  VALID_OPTIONS    = [:threshold, :pretend, :verbose, :recursive]
  VALID_INTERVALS  = [:hourly, :daily, :weekly, :monthly, :yearly]
  TIME_INTERVALS   = [:hour,   :day,   :cweek, :month, :year]

  SimpleFile = Struct.new(:path, :stat) do
    delegate :ctime, :file?, :directory?, :to => :stat
  end

  def initialize(paths, options = {})
    @paths = [paths].flatten
    @options = options.reverse_merge(:threshold => 30.days.ago)
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
    FileUtils.rm_rf(files, :noop => !!options[:pretend])
  end

  def files
    if paths.any?{|path| path.include?('*')}
      paths.map!{|path| Dir.glob(path)}
      paths.flatten!
    end
    @_files ||= paths.map do |file_path|
      begin
        SimpleFile.new(file_path, File.stat(file_path))
      rescue Errno::EOPNOTSUPP
        nil
      rescue Errno::ENOENT => e
        puts e.to_s
        exit -2
      end
    end.compact.select do |file|
      file.file? || (options[:recursive] && file.directory?)
    end.sort_by(&:ctime)
  end

  def files_to_delete
    files_before_threshold - files_to_preserve
  end

  def files_before_threshold
    files.select{|file| file.ctime < options[:threshold]}
  end

  def files_to_preserve
    return [] if @key_intervals.nil?
    files_before_threshold.group_by do |file|
      cdate = file.ctime.to_datetime
      @key_intervals.map{|interval| cdate.send(interval)}
    end.map do |_, files|
      files.first
    end
  end
end