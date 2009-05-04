require File.join(File.dirname(__FILE__), '/spec_helper')
  
describe Cleaner do
  
  it 'find files older than threshold' do
    cleaner = Cleaner.new('/path', :threshold => 5.days.ago)
    cleaner.should_receive(:files).and_return(mock_files(7.days.ago, 4.days.ago))
    cleaner.files_before_threshold.should == mock_files(7.days.ago)
  end
  
  it 'preserves the first file of the hour' do
    cleaner = Cleaner.new('/path', :hourly => true)
    files = mock_files('12:05', '12:10', '13:15', '13:16')
    cleaner.should_receive(:files_before_threshold).and_return(files)
    cleaner.files_to_preserve.should == mock_files('12:05', '13:15')
  end
  
  it 'preserves the first file of the day' do
    cleaner = Cleaner.new('/path', :daily => true)
    files = mock_files('01 10:00', '01 12:00', '02 00:00', '02 00:01')
    cleaner.should_receive(:files_before_threshold).and_return(files)
    cleaner.files_to_preserve.should == mock_files('01 10:00', '02 00:00')
  end
  
  it 'preserves the first file of the week' do
    cleaner = Cleaner.new('/path', :weekly => true)
    files = mock_files('Sun Jan 02 03:40 00', 'Tue Jan 04 03:40 00', 'Wed Jan 05 03:40 00')
    cleaner.should_receive(:files_before_threshold).and_return(files)
    cleaner.files_to_preserve.should == mock_files('Sun Jan 02 03:40 00', 'Tue Jan 04 03:40 00')
  end
  
  it 'preserves the first file of the month' do
    cleaner = Cleaner.new('/path', :monthly => true)
    files = mock_files('Sun Jan 02 12:00 00', 'Tue Feb 01 12:00 00', 'Wed Feb 02 12:00 00')
    cleaner.should_receive(:files_before_threshold).and_return(files)
    cleaner.files_to_preserve.should == mock_files('Sun Jan 02 12:00 00', 'Tue Feb 01 12:00 00')
  end
  
  it 'preserves the first file of the year' do
    cleaner = Cleaner.new('/path', :yearly => true)
    files = mock_files('Sun Jan 02 03:40 01', 'Tue Jan 04 03:40 02', 'Wed Jan 05 03:40 02')
    cleaner.should_receive(:files_before_threshold).and_return(files)
    cleaner.files_to_preserve.should == mock_files('Sun Jan 02 03:40 01', 'Tue Jan 04 03:40 02')
  end
  
  MockFile = Struct.new(:ctime) do
    def ==(other)
      (ctime.to_i - other.ctime.to_i) < 2
    end

    def inspect
      ctime.to_s(:short)
    end
  end

  def mock_files(*ctimes)
    ctimes.map do |ctime|
      if ctime.is_a?(String)
        ctime = "1 #{ctime}" unless ctime =~ /\d\d /
        ctime = "May #{ctime} 2009" unless ctime =~  /\d{2}/
        ctime = Time.parse(ctime)
      end
      MockFile.new(ctime)
    end
  end
  
  def should_preserve(values)
    
  end
end