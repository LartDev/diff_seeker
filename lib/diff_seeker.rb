require 'diff_seeker/version'
require 'command_line_reporter'

module DiffSeeker
  extend CommandLineReporter
  module_function

  def compare(file_1_path, file_2_path)
    suppress_output
    f1_lines = File.readlines(file_1_path).map!(&:strip)
    f2_lines = File.readlines(file_2_path).map!(&:strip)
    table(:border => false) do
      process_lines(f1_lines, f2_lines)
    end

    capture_output
  end

  def process_lines(f1_lines, f2_lines)
    index = 1
    loop do
      column2, column3 = get_diff(f1_lines, f2_lines)
      create_row(index, column2, column3)

      f1_lines.shift if f1_lines.any?
      f2_lines.shift if f2_lines.any? && column2 != '-'
      index += 1

      break if f1_lines.empty? && f2_lines.empty?
    end
  end

  def create_row(index, column2, column3)
    row do
      column("#{index}", width: 10)
      column(column2, width: 3)
      column(column3, width: 50)
    end
  end

  def get_diff(f1_lines, f2_lines)
    line1 = f1_lines[0]
    line2 = f2_lines[0]
    next_line1 = f1_lines[1]
    next_line2 = f2_lines[1]
    if line1 && line2.nil?
      column2 = '-'
      column3 = line1
    elsif line2 && line1.nil?
      column2 = '+'
      column3 = line2
    elsif line1 == line2
      column2 = ' '
      column3 = line1
    elsif line1 != line2 && line_removed?(next_line1, line2)
      column2 = '-'
      column3 = line1
    else line1 != line2
      column2 = '*'
      column3 = "#{line1}|#{line2}"
    end

    [column2, column3]
  end

  def line_removed?(next_line1, line2)
    next_line1 && next_line1 == line2
  end
end
