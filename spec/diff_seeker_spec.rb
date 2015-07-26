require 'spec_helper'

describe DiffSeeker do
  include CommandLineReporter

  it 'has a version number' do
    expect(DiffSeeker::VERSION).not_to be nil
  end

  it 'compares 2 files correctly' do
    expected = "1          *   Some|Another                                       \n2" +
               "          -   Simple                                             \n3" +
               "              Text                                               \n4" +
               "              File                                               \n5" +
               "          +   With                                               \n6" +
               "          +   Additional                                         \n7" +
               "          +   Lines                                              \n"
    f1_path = 'spec/fixtures/file1.txt'
    f2_path = 'spec/fixtures/file2.txt'

    result = DiffSeeker.compare(f1_path, f2_path)
    puts result
    expect(result).to eq expected
  end
end
