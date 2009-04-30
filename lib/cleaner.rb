class Cleaner
  
  attr_reader :path, :options
  
  def initialize(path, options)
    @path = path
    @options = options
  end
  
  def start
    puts 'would delete: '
    files_before_threshold.each {|file_name| puts file_name}
  end
  
  def files_before_threshold
    raise "No such directory: #{path}" unless File.directory?(path)
    all_file_paths = Dir.glob(path + '/*')
    all_file_paths.select{|file_path| File.ctime(file_path) < options[:threshold]}
  end
end