require File.join(File.dirname(__FILE__), '/spec_helper')

describe Cleaner do
  
  it 'find files older than threshold' do
    File.should_receive(:ctime).exactly(2).times.and_return(7.days.ago, 4.days.ago)
    Dir.should_receive(:glob).with('/some/path/*').and_return(['old_file', 'new_file'])
    File.should_receive(:directory?).and_return(true)
    cleaner = Cleaner.new('/some/path', :threshold => 5.days.ago)
    cleaner.files_before_threshold.should == ['old_file']
  end
end
