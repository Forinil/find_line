#!/usr/bin/env ruby

require 'English'
require_relative 'custom_logger'

begin
  logger = CustomLogger.new($PROGRAM_NAME)

  if ARGV.length < 2
    puts "Usage:\n ./#{File.basename($PROGRAM_NAME)} "\
      'directory_path regexp output_file_name_suffix (optional)'
    exit
  end

  path = ARGV[0]
  text_to_find = Regexp.new(ARGV[1])
  a2 = ARGV[2]
  result_name = a2.nil? ? "result_#{text_to_find.inspect.gsub!(/\//, '')}.txt" : "result_#{a2}.txt"
  result = File.new(result_name, 'w:utf-8')

  logger.log(Logger::INFO,
             "Path to search: #{path}, regexp to find: #{text_to_find.inspect}")

  files = Dir.entries(path)

  files.each do |file_name|
    next if File.directory?("#{path}\\#{file_name}")
    logger.log(Logger::INFO, "Opening #{path}\\#{file_name}"\
      " to search for #{text_to_find.inspect}")

    line_number = 1
    file = File.open("#{path}\\#{file_name}", 'r')
    contents = file.readlines
    output = []

    contents.each do |line|
      begin
        res = (line =~ text_to_find)
        output << "#{line_number}: #{line}" unless res.nil?
        line_number += 1
      rescue => err
        logger.log(Logger::ERROR,
                   "Error: #{err} while processing line no: #{line_number}"\
					" from #{$ERROR_POSITION}")
        exit(false)
      end
    end

    unless output.empty?
      result.puts("File: #{file_name}")
      result.puts(output)
      result.puts
    end

    file.close
  end

  logger.log(Logger::INFO, "Results saved to file: #{result_name}")

  result.close
rescue => err
  message = "Error: #{err} from #{$ERROR_POSITION}"
  if logger.nil?
    puts(message)
  else
    logger.log(Logger::FATAL) { message }
  end
end
