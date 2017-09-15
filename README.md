# find_line
A simple grep-like script written in Ruby

**Usage:** `./find_line directory_path regexp output_file_name_suffix (optional)`

- `directory path` - directory with files to search for occurrences of the pattern
- `regexp` - pattern occurrences of which to search for
- `output_file_name_suffix` - output file will be named result_#{output_file_name_suffix}.txt if this parameter is specified,
    otherwise it will be named result_#{regexp.inspect}.txt
    
Script stores log files in directory path specified in `LOG_PATH` environmental variable.
If that variable is not set, log files are being stored in the directory containing the script.   
    
**Warning:** if your regexp contains characters that cannot be a part of file name in your operating system, the script will 
exit with error unless `output_file_name_suffix` is specified     