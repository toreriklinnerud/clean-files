require File.join(File.dirname(__FILE__), '/spec_helper')

module CleanFiles
  describe Cleaner do

    it 'find files older than threshold' do
      cleaner = Cleaner.new('/path', :threshold => 5.days.ago)
      cleaner.should_receive(:files).and_return(mock_files(7.days.ago, 4.days.ago))
      cleaner.files_before_threshold.should == mock_files(7.days.ago)
    end

    it 'deletes files' do
       cleaner = Cleaner.new('/path')
       files = mock_files(3.days.ago, 2.days.ago, 7.days.ago)
       cleaner.should_receive(:files_to_delete).and_return(files)
       FileUtils.should_receive(:rm_rf).with(files.map(&:path), :noop => false)
       cleaner.start
    end

    it 'does not delete any files if specifying pretend => true' do
       cleaner = Cleaner.new('/path', :pretend => true)
       files = mock_files(3.days.ago, 2.days.ago, 7.days.ago)
       cleaner.should_receive(:files_to_delete).and_return(files)
       FileUtils.should_receive(:rm_rf).with(files.map(&:path), :noop => true)
       cleaner.start
    end

    it 'has has files to delete' do
      cleaner = Cleaner.new('/path')
      cleaner.should_receive(:files_before_threshold).and_return(mock_files('12:00', '13:00'))
      cleaner.should_receive(:files_to_preserve).and_return(mock_files('13:00'))
      cleaner.files_to_delete.should == mock_files('12:00')
    end

    it 'prints name of file to be deleted if specifying verbose => true' do
       cleaner = Cleaner.new('/path', :verbose => true)
       files = mock_files('00:50', '13:30')
       cleaner.should_receive(:files_to_delete).and_return(files)
       FileUtils.should_receive(:rm_rf).with(files.map(&:path), :noop => false)
       cleaner.should_receive(:puts).with("01 May 00:50\n01 May 13:30")
       cleaner.start
    end

    it 'preserves the first file of the hour' do
      should_preserve(:hourly,
        '12:05' => true,
        '12:10' => false,
        '13:15' => true,
        '13:16' => false)
    end

    it 'preserves the first file of the day' do
      should_preserve(:daily,
        '01 10:00' => true,
        '01 12:00' => false,
        '02 00:00' => true,
        '02 00:01' => false)
    end

    it 'preserves the first file of the week' do
      should_preserve(:weekly,
        'Sun Jan 02 03:40 00' => true,
        'Tue Jan 04 03:40 00' => true,
        'Wed Jan 05 03:40 00' => false)
    end

    it 'preserves the first file of the month' do
      should_preserve(:monthly,
        'Sun Jan 02 12:00 00' => true,
        'Tue Feb 01 12:00 00' => true,
        'Wed Feb 02 12:00 00' => false)
    end

    it 'preserves the first file of the year' do
      should_preserve(:yearly,
        'Sun Jan 02 03:40 01' => true,
        'Tue Jan 04 03:40 02' => true,
        'Wed Jan 05 03:40 02' => false)
    end

    MockFile = Struct.new(:ctime) do
      def ==(other)
        (ctime.to_i - other.ctime.to_i) < 2
      end

      def inspect
        ctime.to_s(:short)
      end

      def stat
        stat = Object.new
        def stat.file?
          true
        end
        stat
      end

      alias path inspect
    end

    def mock_files(*ctimes)
      ctimes.map do |ctime|
        if ctime.is_a?(String)
          ctime = "1 May #{ctime}" unless ctime =~ /\d\d /
          ctime = "May #{ctime} 2009" unless ctime =~  /\d{2}/
          ctime = Time.parse(ctime)
        end
        MockFile.new(ctime)
      end
    end

    def should_preserve(interval, files)
      cleaner = Cleaner.new('/path', interval => true)
      cleaner.should_receive(:files_before_threshold).and_return(mock_files(*files.keys.sort))
      expected_files = files.select{|_, select| select == true}.map{|file, _| file}
      cleaner.files_to_preserve.to_set.should == mock_files(*expected_files).to_set
    end
  end
end