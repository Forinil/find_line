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

  # path = "D:\\Logi\\SGSB\\UAT\\integration.2017-08-07"
  # path = "D:\\Logi\\SGSB\\UAT\\integration.2017-08-24"
  # path = "D:\\Logi\\SGSB\\UAT\\integration.2017-08-25"
  # path = "D:\\Logi\\SGSB\\UAT\\integration.2017-08-26"
  # path = "D:\\Logi\\SGSB\\UAT\\integration.2017-08-27"
  # path = "D:\\Logi\\SGSB\\UAT\\integration.2017-08-28"
  # path = "D:\\Logi\\SGSB\\UAT\\integration.2017-08-29"
  # path = "D:\\Logi\\SGSB\\UAT\\integration"
  # path = "D:\\Logi\\SGSB\\PROD\\integration"
  # path = "D:\\Logi\\SGSB\\PREPROD\\web-api.2017-09-01"
  # path = "D:\\Logi\\SGSB\\PROD\\integration.2017-09-04"
  # path = "D:\\Logi\\SGSB\\PROD\\csf.2017-09-04"
  # path = "D:\\Logi\\SGSBC\\PROD\\2017-09-06"
  # path = "D:\\Logi\\SGSB\\PROD\\cwi.2017-09-01"
  # path = 'D:\\Logi\\SGSB\\PROD\\web-api.2017-09-07'
  # text_to_find = /ProductFilesServiceImpl\]- getFiles args: \[ACCOUNTS, 4684782\]/
  # text_to_find = /EmailsRepositoryImpl/
  # text_to_find = /ForeignBanks/
  # text_to_find = /\/deposit\/sendContract/
  # text_to_find = /<dep:REFERENCE_ID>354370<\/dep:REFERENCE_ID>/
  # text_to_find = /40667271/
  # text_to_find = /B6A1FEBBE2BE6D2EA9F4D29A0951547D/

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
